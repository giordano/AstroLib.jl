# This file is a part of AstroLib.jl. License is MIT "Expat".
# Copyright (C) 2016 Mosè Giordano.

"""
    jdcnv(date::DateTime) -> Float64

### Purpose ###

Convert proleptic Gregorian Calendar date in UTC standard to number of Julian
days.

### Explanation ###

Takes the given proleptic Gregorian date in UTC standard and returns the number
of Julian calendar days since epoch `-4713-11-24T12:00:00`.

### Argument ###

* `date`: date of `DateTime` type, in proleptic Gregorian Calendar.

### Output ###

Number of Julian days, as a `Float64`.


### Example ###

Find the Julian days number at 2009 August 23, 03:39:06.

```
julia> jdcnv(DateTime(2009, 08, 23, 03, 39, 06))
2.4550666521527776e6
```

### Notes ###

This is the inverse of `daycnv`.

`get_juldate` returns the number of Julian days for current time.  It is
equivalent to `jdcnv(Dates.now())'.

For the conversion of Julian date to number of Julian days, use `juldate`.
"""
const jdcnv = Dates.datetime2julian
