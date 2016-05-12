# This file is a part of AstroLib.jl. License is MIT "Expat".
# Copyright (C) 2016 Mosè Giordano.

"""
    get_date([date, old=true, timetag=true]) -> string

### Purpose ###

Returns the UTC date in `"CCYY-MM-DD"` format for FITS headers.

### Explanation ###

This is the format required by the `DATE` and `DATE-OBS` keywords in a FITS
header.

### Argument ###

* `date` (optional): the date in UTC standard, of `DateTime` type.  If omitted,
  defaults to the current UTC time.  It can be either a single date or an array
  of dates.  When it is a single date, it can be a `DateTime` type or anything
  that can be converted to that type.  If you are providing an array of dates,
  they can be of type `DateTime`, `Date`, or an `AbstractString` that can be
  directly converted to `DateTime`.  Note that you must provide homogeneous
  arrays, you cannot mix element with different types.
* `old` (optional boolean keyword): see below.
* `timetag` (optional boolean keyword): see below.

### Output ###

A string with the date formatted according to the given optional keywords.

* When no optional keywords (`timetag` and `old`) are supplied, the format of
  the output string is `"CCYY-MM-DD"` (year-month-day part of the date), where
  `CCYY` represents a 4-digit calendar year, `MM` the 2-digit ordinal number of
  a calendar month within the calendar year, and `DD` the 2-digit ordinal number
  of a day within the calendar month.
* If the boolean keyword `old` is true (default: false), the year-month-day part
  of date has `"DD/MM/YY"` format.  This is the formerly (pre-1997) recommended
  for FITS.  Note that this format is now deprecated because it uses only a
  2-digit representation of the year.
* If the boolean keyword `timetag` is true (default: false), `"Thh:mm:ss"` is
  appended to the year-month-day part of the date, where <hh> represents the
  hour in the day, <mm> the minutes, <ss> the seconds, and the literal 'T' the
  ISO 8601 time designator.

Note that `old` and `timetag` keywords can be used together, so that the output
string will have `"DD/MM/YYThh:mm:ss"` format.

### Example ###

``` julia
julia> get_date(timetag=true)
"2016-03-14T11:26:23"
```

### Notes ###

1. A discussion of the DATExxx syntax in FITS headers can be found in
 http://www.cv.nrao.edu/fits/documents/standards/year2000.txt

2. Those who wish to use need further flexibility in their date formats (e.g. to
 use TAI time) should look at Bill Thompson's time routines in
 http://sohowww.nascom.nasa.gov/solarsoft/gen/idl/time
"""
function get_date(dt::DateTime, old::Bool, timetag::Bool)
    # Based on `Base.string' definition in base/dates/io.jl.
    y, m, d = Dates.yearmonthday(dt)
    h, mi, s = Dates.hour(dt), Dates.minute(dt), Dates.second(dt)

    yy = lpad(y,4,"0") # here y is supposed to be positive.
    mm = lpad(m,2,"0")
    dd = lpad(d,2,"0")
    hh = lpad(h,2,"0")
    mii = lpad(mi,2,"0")
    ss = lpad(s,2,"0")

    # Set year-month-day string (ymds).
    ymds = old ? "$(dd)/$(mm)/$(yy)" : "$(yy)-$(mm)-$(dd)"

    if timetag
        return "$(ymds)T$(hh):$(mii):$(ss)"
    else
        return ymds
    end
end

# Scalar function
get_date(dt::DateTime=Dates.unix2datetime(Libc.time());
         old::Bool=false, timetag::Bool=false) = get_date(dt, old, timetag)

get_date(dt...; old::Bool=false, timetag::Bool=false) =
    get_date(DateTime(dt...), old, timetag)

# Vectorial function
function get_date{D<:DateTime}(dt::AbstractArray{D};
                               old::Bool=false, timetag::Bool=false)
    dates = similar(dt, String)
    for i in eachindex(dt)
        dates[i] = get_date(dt[i], old, timetag)
    end
    return dates
end

function get_date{D<:Date}(dt::AbstractArray{D};
                           old::Bool=false, timetag::Bool=false)
    dates = similar(dt, String)
    for i in eachindex(dt)
        dates[i] = get_date(dt[i], old=old, timetag=timetag)
    end
    return dates
end

function get_date{S<:AbstractString}(dt::AbstractArray{S};
                           old::Bool=false, timetag::Bool=false)
    dates = similar(dt, String)
    for i in eachindex(dt)
        dates[i] = get_date(dt[i], old=old, timetag=timetag)
    end
    return dates
end
