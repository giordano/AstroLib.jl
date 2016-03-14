# This file is a part of AstroLib.jl. License is MIT "Expat".
# Copyright (C) 2016 Mosè Giordano.

# This function is based on IDL Astronomy User's Library.

"""
    juldate(date::DateTime) -> Float64

Takes the given `DateTime` and returns the number of Julian calendar days since
epoch `1858-11-16T12:00:00` (Reduced Julian Date = Julian Date - 2400000) as a
`Float64`.

**NOTE:** Before `1582-10-15T00:00:00` the date is assumed to be in Julian
Calendar, thus before this date `juldate` is *not* the inverse of `daycnv`.  For
the conversion of Gregorian date to number of Julian days, use `jdcnv`, which is
the inverse of `daycnv`.
"""
# Before 1582-10-15 Dates.datetime2julian uses proleptic Gregorian Calendar,
# instead AstroLib's juldate uses Julian Calendar.  In addition, after that day
# using Dates.datetime2julian(date)-2.4e6 would give results not precise enough.
# For all these reasons, we use here the same algorithm as AstroLib's juldate.
function juldate(dt::DateTime)
    year, month, day = Dates.yearmonthday(dt)
    hours, minutes, seconds = Dates.hour(dt), Dates.minute(dt), Dates.second(dt)

    if year < 0
        year += 1
    else
        year == 0 && error("There is no year zero in Julian Calendar")
    end

    day = day + (hours + minutes/60.0 + seconds/3600.0)/24.0

    # Do not include leap year in January and February.
    if month < 3
        year -= 1
        month += 12
    end

    jd = fld(year, 4.0) + 365.0*(year - 1860.0) + floor(30.6001*(month + 1.0)) +
         day - 105.5

    # Adjust for Gregorian Calendar, started on 1582-10-15 (= RJD -100830.5).
    if jd > -100830.5
        a = trunc(year/100.0)
        jd += 2.0 - a + fld(a, 4.0)
    end
    return jd
end
