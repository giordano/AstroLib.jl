# This file is a part of AstroLib.jl. License is MIT "Expat".
# Copyright (C) 2016 Mosè Giordano.

"""
    ct2lst(longitude, jd) -> local_sidereal_time
    ct2lst(longitude, tz, date) -> local_sidereal_time

### Purpose ###

Convert from Local Civil Time to Local Mean Sidereal Time.

### Arguments ###

The function can be called in two different ways.  The only argument common to
both methods is `longitude`:

* `longitude`: the longitude in degrees (east of Greenwich) of the place for
  which the local sidereal time is desired, scalar.  The Greenwich mean sidereal
  time (GMST) can be found by setting longitude = `0`.

The civil date to be converted to mean sidereal time can be specified either by
providing the Julian days:

* `jd` (optional numeric keyword): this is number of Julian days for the date to
  be converted.  It can be a scalar or an array.

or the time zone and the date:

* `tz`: the time zone of the site in hours, positive East of the
  Greenwich meridian (ahead of GMT).  Use this parameter to easily
  account for Daylight Savings time (e.g. -4=EDT, -5 = EST/CDT), scalar.
  * `date`: this is the local civil time with type `DateTime`.  It can
  be a scalar or an array.

### Output ###

The local sidereal time for the date/time specified in hours.  This is a scalar
or an array of the same length as `jd` or `date`.

### Method ###

The Julian days of the day and time is question is used to determine the number
of days to have passed since 2000-01-01.  This is used in conjunction with the
GST of that date to extrapolate to the current GST; this is then used to get the
LST.  See Astronomical Algorithms by Jean Meeus, p. 84 (Eq. 11-4) for the
constants used.

### Example ###

Find the Greenwich mean sidereal time (GMST) on 2008-07-30 at 15:53 in
Baltimore, Maryland (longitude=-76.72 degrees).  The timezone is EDT or tz=-4

``` julia
julia> ct2lst(-76.72, -4, DateTime(2008, 7, 30, 15, 53))
11.356505172312609

julia> sixty(ans)
3-element Array{Float64,1}:
 11.0    # Hours
 21.0    # Minutes
 23.4186 # Seconds
```

Find the Greenwich mean sidereal time (GMST) on 2015-11-24 at 13:21 in
Heidelberg, Germany (longitude=08° 43' E).  The timezone is CET or tz=1.
Provide `ct2lst` only with the longitude of the place and the number of
Julian days.

``` julia
# Convert longitude to decimals.
julia> longitude=ten(8, 43)
8.716666666666667

# Get number of Julian days.  Remember to subtract the time zone in
# order to convert local time to UTC.
julia> jd = jdcnv(DateTime(2015, 11, 24, 13, 21) - Dates.Hour(1))
2.4573510145833334e6

# Calculate Greenwich Mean Sidereal Time.
julia> ct2lst(longitude, jd)
17.140685171005316

julia> sixty(ans)
3-element Array{Float64,1}:
 17.0    # Hours
  8.0    # Minutes
 26.4666 # Seconds
```

### Notes ###

Code of this function is based on IDL Astronomy User's Library.
"""
function ct2lst{T<:AbstractFloat}(long::T, jd::T)
    # Useful constants, see Meeus, p.84.
    c  = [280.46061837, 360.98564736629, 0.000387933, 38710000.0]
    jd2000 = 2451545.0
    t0 = jd - jd2000
    t  = t0/36525.0
    # Compute GST in seconds.
    theta = c[1] + (c[2]*t0) + t^2*(c[3] - t/c[4])
    return cirrange((theta + long)/15.0, 24.0)
end

ct2lst(long::Real, jd::Real) = ct2lst(promote(float(long), float(jd))...)

function ct2lst{T<:AbstractFloat}(long::T, tz::T,
                                  date::DateTime)
    # In order to handle time zones, package "TimeZones.jl" is much better, bur
    # here we need only to add the time zone to UTC time.  All time zones I know
    # are either integer, or ±30 or ±45 minutes, so it should be safe enough to
    # convert hours to minutes and subtract minutes from "time".
    date = date - Dates.Minute(round(Int64, tz*60))
    return ct2lst(long, jdcnv(date))
end

ct2lst(long::Real, tz::Real,
       date::DateTime=Dates.now()) =
           ct2lst(promote(float(long), float(tz))..., date)


# Vectorial versions
function ct2lst{D<:DateTime}(long::Real, tz::Real, date::AbstractArray{D})
    lst = similar(date, typeof(float(long)))
    for i in eachindex(date)
        lst[i] = ct2lst(long, tz, date[i])
    end
    return lst
end

function ct2lst{JD<:Real}(long::Real, jd::AbstractArray{JD})
    lst = similar(jd, typeof(float(long)))
    for i in eachindex(jd)
        lst[i] = ct2lst(long, jd[i])
    end
    return lst
end
