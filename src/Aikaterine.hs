module Aikaterine where

import qualified Data.Text as T
import Data.Maybe
import Data.Graph.Inductive
import Data.Bits
import qualified Data.Vector as V
import qualified Data.Map as M

newtype RegionIdentifier = RegionIdentifier (V.Vector T.Text)
  deriving (Eq, Ord)

regionIdentifier :: T.Text -> Maybe RegionIdentifier
regionIdentifier pri =
  if any T.null pri'
  then Nothing
  else Just (RegionIdentifier (V.fromList pri'))
    where
      pri' = T.split (=='.') pri

data Idea n = Idea { region     :: RegionIdentifier
                   , name       :: T.Text
                   , value      :: n }

newtype Relation = Relation T.Text

newtype KnowledgeGraph n = KnowledgeGraph (Gr (Idea n) Relation)

data Region = Region RegionIdentifier (V.Vector Node) (V.Vector Region)

regionsFromGraph :: KnowledgeGraph n -> Region
regionsFromGraph (KnowledgeGraph kn) =
  createRegion (M.map V.fromList (getRegions (labNodes kn) M.empty)) 1
    where
      unwrapRegionIdentifier (RegionIdentifier ri) = ri
      createRegion m l =
        Region ri (sortNodes (fromMaybe V.empty (M.lookup ri m)))
               (sortRegions (partitionRegions (M.delete ri m) V.empty))
          where
            ri = RegionIdentifier (V.take l (unwrapRegionIdentifier (fst (M.elemAt 0 m))))
            partitionRegions m v =
              if M.null m then v else partitionRegions (snd p) (V.cons (createRegion (fst p) (l+1)) v)
                where
                  sr = V.take (l+1) (unwrapRegionIdentifier (fst (M.elemAt 0 m)))
                  p = M.partitionWithKey (\ (RegionIdentifier k) _ -> (V.take (l+1) k) == sr) m
      updateRegion i mis =
        case mis of
          Just is -> Just (i:is)
          Nothing -> Just [i]
      getRegions [] rm = rm
      getRegions (i:is) rm =
        getRegions is (M.alter (updateRegion (fst i)) (region (snd i)) rm)
      radixSortBy v f = radixSortBy' v f 0 (finiteBitSize (0 :: Int))
      radixSortBy' v f i m =
        if i > m then v else radixSortBy' ((fst part) V.++ (snd part)) f (i + 1) m
          where part = V.partition (\ x -> testBit (f x) i) v
      sortNodes n = radixSortBy n (deg kn)
      sortRegions r = radixSortBy r degree
      degree (Region _ n r) =
        (V.foldr (\ r -> (+) (degree r)) 0 r) + (V.foldr (\ n -> (+) (deg kn n)) 0 n)

data Position = Position { x :: Float
                         , y :: Float }

type NodePositions = M.Map Node Position

minEdgeLen :: Float
minEdgeLen = 2

nodeDiameter :: Float
nodeDiameter = 1

minNodeDist :: Float
minNodeDist = nodeDiameter + minEdgeLen

positionCircle :: Float -> Int -> V.Vector Node -> NodePositions -> Float -> Float -> NodePositions
positionCircle r n ns m x y =
  if V.null ns
  then m
  else positionCircle r n (V.tail ns) (M.insert (V.head ns) (Position x y) m) (c*x - s*y) (s*x + c*y)
    where
      theta = 2 * (pi :: Float) / (fromIntegral n)
      c = cos theta
      s = sin theta

positionNodes :: V.Vector Node -> NodePositions
positionNodes ns = positionNodes' 0 1 ns M.empty

positionNodes' :: Int -> Int -> V.Vector Node -> NodePositions -> NodePositions
positionNodes' l n ns m =
  if V.null ns
  then m
  else positionNodes' (l + 1) (n + 4) (V.drop n ns)
                     (positionCircle nodeDist (min n (V.length ns)) ns m 0 nodeDist)
    where
      nodeDist = (fromIntegral l) * minNodeDist
