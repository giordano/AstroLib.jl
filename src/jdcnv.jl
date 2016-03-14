# This file is a part of AstroLib.jl. License is MIT "Expat".
# Copyright (C) 2016 Mosè Giordano.

# This function is based on IDL Astronomy User's Library.

"""
    jdcnv(date::DateTime) -> Float64

Takes the given Gregorian `DateTime` and returns the number of Julian calendar
days since epoch `-4713-11-24T12:00:00` as a `Float64`.

If `date` is before `1582-10-15T00:00:00` the proleptic Gregorian Calendar is
assumed.

This is the inverse of `daycnv`.

For the conversion of Julian date to number of Julian days, use `juldate`.
"""
const jdcnv = Dates.datetime2julian
