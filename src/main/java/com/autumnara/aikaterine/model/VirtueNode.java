package com.autumnara.aikaterine.model;

/** A virtue represented as a node.
  * 
  * A virtue with a node representation in two-dimensional space. The
  * representation is a circle with a defined position and color.
  * Virtues that have similar colors ought to be similar.
  */
final class VirtueNode extends Virtue
{

    /** Constructor for a virtue represented as a node.
      */
    VirtueNode(String   name,
               String   description,
               Position position,
               Color    color)
    {
        super(name, description);
        this.position    = position;
        this.color       = color;
    }

    /** The position of the node in space.
      */
    Position position;

    /** The color of the virtue.
      */
    Color color;

}
