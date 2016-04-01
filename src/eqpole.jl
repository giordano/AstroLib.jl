# This file is a part of AstroLib.jl. License is MIT "Expat".
# Copyright (C) 2016 Mosè Giordano.

"""
    eqpole(l, b) -> x, y

### Purpose ###

Convert right ascension \$l\$ and declination \$b\$ to coordinate \$(x, y)\$
using an equal-area polar projection.

### Explanation ###

The output \$x\$ and \$y\$ coordinates are scaled to be in the range \$[-90, 90]\$
and to go from equator to pole to equator.  Output map points can be
centered on the north pole or south pole.

### Arguments ###

* `l`: longitude, scalar or vector, in degrees
* `b`: latitude, same number of elements as right ascension, in degrees
* `southpole` (optional boolean keyword): keyword to indicate that the plot is
  to be centered on the south pole instead of the north pole.  Default is
  `false`.

### Output ###

The 2-tuple \$(x, y)\$:

* \$x\$ coordinate, same number of elements as right ascension, normalized to be
  in the range \$[-90, 90]\$.
* \$y\$ coordinate, same number of elements as declination, normalized to be
  in the range \$[-90, 90]\$.

### Example ###

``` julia
julia> eqpole(100, 35, southpole=true)
(-111.18287262822456,-19.604540237028665)

julia> eqpole(80, 19)
(72.78853915267848,12.83458333897169)
```

### Notes ###

Code of this function is based on IDL Astronomy User's Library.
"""
function eqpole{T<:AbstractFloat}(l::T, b::T; southpole::Bool=false)
    sgn = southpole ? -1.0 : 1.0
    l = deg2rad(sgn*l)
    b = deg2rad(sgn*b)
    sq = 2.0*(1.0 - sin(b))
    sq = sq >= 0.0 ? sq : 0.0
    r = 18.0*3.53553391*sqrt(sq)
    # TODO: output is of type Any when input l and b are integer scalars (but
    # not when are integer arrays).
    return r*sin(l), r*cos(l)
end

eqpole(l::Real, b::Real; southpole::Bool=false) =
    eqpole(promote(float(l), float(b))..., southpole=southpole)

function eqpole{L<:Real, B<:Real}(l::AbstractArray{L},
                                  b::AbstractArray{B};
                                  southpole::Bool=false)
    @assert length(l) == length(b)
    typel = typeof(float(one(L)))
    x = similar(l, typel)
    y = similar(l, typel)
    for i in eachindex(l)
        x[i], y[i] = eqpole(l[i], b[i], southpole=southpole)
    end
    return x, y
end
