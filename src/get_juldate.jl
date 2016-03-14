# This file is a part of AstroLib.jl. License is MIT "Expat".
# Copyright (C) 2016 Mosè Giordano.

"""
    get_juldate() --> Float64

### Purpose ###

Return the number of Julian days for current time.

### Explanation ###

Return for current time the number of Julian calendar days since epoch
`-4713-11-24T12:00:00` as a `Float64`.

### Example ###

```
julia> get_juldate()
2.4574620222685183e6

julia> daycnv(get_juldate())
2016-03-14T12:32:13
```

### Notes ###
Use `jdcnv` to get the number of Julian days for a different date.
"""
get_juldate() = jdcnv(Dates.now())
