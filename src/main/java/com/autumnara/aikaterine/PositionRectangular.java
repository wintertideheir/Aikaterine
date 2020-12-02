package com.autumnara.aikaterine;

import static java.lang.Math.*;

/** A position expressed in rectangular Cartesian coordinates. */
public final class PositionRectangular
{

    /** The x-coordinate of this position. */
    public final float x;

    /** The y-coordinate of this position. */
    public final float y;

    /** Constructor for a position from x- and y-coordinates. */
    public PositionRectangular(float x,
                               float y)
    {
        this.x = x;
        this.y = y;
    }

    /** Constructor for a postion from polar coordinates. */
    public PositionRectangular(PositionPolar pos)
    {
        this.x = (float) cos(pos.angle) * pos.radius;
        this.y = (float) sin(pos.angle) * pos.radius;
    }
}
