# This file is a part of AstroLib.jl. License is MIT "Expat".
# Copyright (C) 2016 Mosè Giordano.

"""
    jdcnv(date) -> julian_days

### Purpose ###

Convert proleptic Gregorian Calendar date in UTC standard to number of Julian
days.

### Explanation ###

Takes the given proleptic Gregorian date in UTC standard and returns the number
of Julian calendar days since epoch `-4713-11-24T12:00:00`.

### Argument ###

* `date`: date in proleptic Gregorian Calendar.  Can be either a scalar or an
  array.

When the argument is a single date, following types are recognized:

* `DateTime`
* anything that can be converted to `DateTime`.  For example, you can specify
  the date by parts (`(y[, m, d, h, mi, s, ms])`), or as a string accepted by
  `DateTime`, or as a `Date` type.

When `date` is an array it accepts the elements of the following types:

* `DateTime`
* `Date`
* `AbstractString` that can be directly parsed by `DateTime`.

Arrays must be homogenous, you cannot mix elements of different type.

Note that in all cases missing parts of the date are assumed to be zero.

### Output ###

Number of Julian days, as a floating point.

### Example ###

Find the Julian days number at 2016 August 23, 03:39:06.

``` julia
julia> jdcnv(DateTime(2016, 08, 23, 03, 39, 06))
2.4576236521527776e6

julia> jdcnv(2016, 08, 23, 03, 39, 06)
2.4576236521527776e6

julia> jdcnv("2016-08-23T03:39:06")
2.4576236521527776e6
```

### Notes ###

This is the inverse of `daycnv`.

`get_juldate` returns the number of Julian days for current time.  It is
equivalent to `jdcnv(Dates.now())`.

For the conversion of Julian date to number of Julian days, use `juldate`.
"""
const jdcnv = Dates.datetime2julian
jdcnv(date...) = jdcnv(DateTime(date...))

@vectorize_1arg Date jdcnv
@vectorize_1arg AbstractString jdcnv
