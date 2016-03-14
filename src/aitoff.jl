# This file is a part of AstroLib.jl. License is MIT "Expat".
# Copyright (C) 2016 Mosè Giordano.

# This function is based on IDL Astronomy User's Library.

"""
    aitoff(l, b) -> (Float64, Float64)

Takes longitude `l` and latitude `b`, both in degrees, and returns the
corresponding Aitoff coordinates `(x, y)`.  `x` is normalized to be in [-180,
180], `y` is normalized to be in [-90, 90].

Both coordinates may be either a scalar or an array, of the same dimension N,
the output coordinates are always Float64 and have the same type (scalar or
array) as the input coordinates.

This function can be used to create an all-sky map in Galactic coordinates with
an equal-area Aitoff projection.  Output map coordinates are zero longitude
centered.

See AIPS memo No. 46
(ftp://ftp.aoc.nrao.edu/pub/software/aips/TEXT/PUBL/AIPSMEMO46.PS), page 4, for
details of the algorithm.  This version of `aitoff` assumes the projection is
centered at b=0 degrees.
"""
function aitoff(l::Number, b::Number)
    l > 180.0 && (l -= 360.0)
    alpha2 = deg2rad(l/2.0)
    delta = deg2rad(b)
    r2 = sqrt(2.0)
    f = 2.0*r2/pi
    cdec = cos(delta)
    denom = sqrt(1.0 + cdec*cos(alpha2))
    return rad2deg(cdec*sin(alpha2)*2.0*r2/denom/f), rad2deg(sin(delta)*r2/denom/f)
end
function aitoff{L<:Number,B<:Number}(l::AbstractArray{L}, b::AbstractArray{B})
    @assert length(l) == length(b)
    x = similar(l, Float64)
    y = similar(b, Float64)
    for i in eachindex(l)
        x[i], y[i] = aitoff(l[i], b[i])
    end
    return x, y
end
