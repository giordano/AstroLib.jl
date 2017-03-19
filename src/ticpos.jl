# This file is a part of AstroLib.jl. License is MIT "Expat".

function _ticpos{T<:AbstractFloat}(deglen::T, pixlen::T, ticsize::T)
    minpix = deglen*60/pixlen
    incr = minpix*ticsize

    if incr < 0
        sgn = -1
    else
        sgn = 1
    end

    incr = abs(incr)

    if incr >= 30
        units = "Degrees"
    elseif incr > 0.5
        units = "Arc Minutes"
    else
        units = "Arc Seconds"
    end

    if incr >= 120
        incr = 4
    elseif incr >= 60
        incr = 2
    elseif incr >= 30
        incr = 1
    elseif incr > 15
        incr = 30
    elseif incr >= 10
        incr = 15
    elseif incr >= 5
        incr = 10
    elseif incr >= 2
        incr = 5
    elseif incr >= 1
        incr = 2
    elseif incr > 0.5
        incr = 1
    elseif incr >= 0.25
        incr = 30
    elseif incr >= 0.16
        incr = 15
    elseif incr >= 0.08
        incr = 10
    elseif incr >= 0.04
        incr = 5
    elseif incr >= 0.02
        incr = 2
    else
        incr = 1
    end

    if units == "Degrees"
        minpix = minpix/60
    elseif units == "Arc Seconds"
        minpix = minpix*60
    end

    ticsize = incr/abs(minpix)
    incr = incr*sgn
    return ticsize, incr, units
end

"""
    ticpos(deglen, pixlen, ticsize) -> ticsize, incr, units

### Purpose ###

Specify distance between tic marks for astronomical coordinate overlays

### Explanation ###

User inputs number an approximate distance between tic marks,
and the axis length in degrees. `ticpos` will return a distance
between tic marks such that the separation is a round multiple
in arc seconds, arc minutes, or degrees.

### Arguments ###

* `deglen`: length of axis in DEGREES
* `pixlen`: length of axis in plotting units (pixels)
* `ticsize`: distance between tic marks (pixels).  This value will be
   adjusted by `ticpos` such that the distance corresponds to a round
   multiple in the astronomical coordinate.

### Output ###

The 3-tuple `(ticsize, incr, units)`:

* `ticsize`: distance between tic marks (pixels), positive scalar
* `incr`: incremental value for tic marks in round units given
   by the `units` parameter
* `units`: string giving units of ticsize, either 'Arc Seconds',
  'Arc Minutes', or 'Degrees'

### Example ###

Suppose a 512 x 512 image array corresponds to 0.2 x 0.2 degrees on the sky.
A tic mark is desired in round angular units, approximately every 75 pixels.
Then

``` julia
julia> ticpos(0.2, 512, 75)
(85.33333333333333, 2, "Arc Minutes")
```

i.e. a good tic mark spacing is every 2 arc minutes, corresponding
to 85.333 pixels.

### Notes ###

Code of this function is based on IDL Astronomy User's Library.
"""
ticpos(deglen::Real, pixlen::Real, ticsize::Real) =
    _ticpos(promote(float(deglen), float(pixlen), float(ticsize))...)
