# This file is a part of AstroLib.jl. License is MIT "Expat".
# Copyright (C) 2016 Mosè Giordano.

rad2sec{T<:AbstractFloat}(rad::T) = rad2deg(rad)*3600

"""
    rad2sec(rad) -> seconds

### Purpose ###

Convert from radians to seconds.

### Argument ###

* `rad`: number of radians.  It can be either a scalar or a vector.

### Output ###

The number of seconds corresponding to `rad`.  If `rad` is an array, an array of
the same length is returned.

### Example ###

``` julia
rad2sec(1)
# => 206264.80624709636
```

### Notes ###

Use `sec2rad` to convert seconds to radians.
"""
rad2sec(rad::Real) = rad2sec(float(rad))
