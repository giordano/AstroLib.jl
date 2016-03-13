# This file is a part of AstroLib.jl. License is MIT "Expat".

using Base.Dates

"""
    airtovac(wave_air) -> Float64

Converts air wavelengths to vacuum wavelengths.

`wave_air` can be either a scalar or an array of numbers.  Wavelengths are
corrected for the index of refraction of air under standard conditions.
Wavelength values below 2000 Å will *not* be altered, take care within [1 Å,
2000 Å].

Uses relation of Ciddor (1996), Applied Optics 62, 958.
"""
function airtovac(wave_air::Number)
    wave_vac = convert(Float64, wave_air)
    if wave_vac >= 2000.0
        for iter= 1:2
            sigma2 = (1e4/wave_vac)^2.0 # Convert to wavenumber squared
            # Computer conversion factor.
            fact = 1.0 + 5.792105e-2/(238.0185e0 - sigma2) +
                1.67917e-3/(57.362e0 - sigma2)
            wave_vac = wave_air*fact # Convert Wavelength
        end
    end
    return wave_vac
end
@vectorize_1arg Number airtovac

"""
    aitoff(l, b) -> (Float64, Float64)

Takes longitude `l` and latitude `b`, both in degrees, and returns the
corresponding Aitoff coordinates `(x, y)`.  `x` is normalized to be in [-180,
180], `y` is normalized to be in [-90, 90].

Both coordinates may be either a scalar or an array, of the same dimension N,
the output coordinates are always Float64 and have the same type (scalar or
array) as the input coordinates.

This function can be used to create an all-sky map in Galactic coordinates with
an equal-area Aitoff projection.  Output map coordinates are zero longitude
centered.

See AIPS memo No. 46
(ftp://ftp.aoc.nrao.edu/pub/software/aips/TEXT/PUBL/AIPSMEMO46.PS), page 4, for
details of the algorithm.  This version of `aitoff` assumes the projection is
centered at b=0 degrees.
"""
function aitoff(l::Number, b::Number)
    l > 180.0 && (l -= 360.0)
    alpha2 = deg2rad(l/2.0)
    delta = deg2rad(b)
    r2 = sqrt(2.0)
    f = 2.0*r2/pi
    cdec = cos(delta)
    denom = sqrt(1.0 + cdec*cos(alpha2))
    return rad2deg(cdec*sin(alpha2)*2.0*r2/denom/f), rad2deg(sin(delta)*r2/denom/f)
end
function aitoff{L<:Number,B<:Number}(l::AbstractArray{L}, b::AbstractArray{B})
    @assert length(l) == length(b)
    x = similar(l, Float64)
    y = similar(b, Float64)
    for i in eachindex(l)
        x[i], y[i] = aitoff(l[i], b[i])
    end
    return x, y
end

"""
    altaz2hadec(alt, az, lat) -> (Float64, Float64)

Convert Horizon (Alt-Az) coordinates to Hour Angle and Declination.

Input coordinates may be either a scalar or an array, of the same dimension N,
the output coordinates are always Float64 and have the same type (scalar or
array) as the input coordinates.

INPUTS
  alt - the local apparent altitude, in DEGREES, scalar or vector
  az  - the local apparent azimuth, in DEGREES, scalar or vector,
        measured EAST of NORTH!!!  If you have measured azimuth west-of-south
        (like the book MEEUS does), convert it to east of north via:
                      az = (az + 180) % 360

  lat -  the local geodetic latitude, in DEGREES, scalar or vector.

OUTPUTS
  ha  -  the local apparent hour angle, in DEGREES.  The hour angle is the
         time that right ascension of 0 hours crosses the local meridian.
         It is unambiguously defined.
  dec -  the local apparent declination, in DEGREES.
"""
function altaz2hadec(alt::Number, az::Number, lat::Number)
    # Convert to radians.
    alt_r = deg2rad(alt)
    az_r = deg2rad(az)
    lat_r = deg2rad(lat)
    # Find local hour angle (in degrees, from 0. to 360.).
    ha = rad2deg(atan2(-sin(az_r)*cos(alt_r),
                       -cos(az_r)*sin(lat_r)*cos(alt_r) +
                       sin(alt_r)*cos(lat_r)))
    ha < 0.0 && (ha += 360.0)
    ha = ha.%360.0
    # Find declination (positive if north of Celestial Equator, negative if
    # south)
    sindec = sin(lat_r)*sin(alt_r) + cos(lat_r)*cos(alt_r)*cos(az_r)
    dec = rad2deg(asin(sindec))  # convert dec to degrees
    return ha, dec
end
function altaz2hadec{N1<:Number, N2<:Number, N3<:Number}(alt::AbstractArray{N1},
                                                         az::AbstractArray{N2},
                                                         lat::AbstractArray{N3})
    @assert length(alt) == length(az) == length(lat)
    ha  = similar(alt, Float64)
    dec = similar(alt, Float64)
    for i in eachindex(alt)
        ha[i], dec[i] = altaz2hadec(alt[i], az[i], lat[i])
    end
    return ha, dec
end

"""
    daycnv(julian_days) -> DateTime

Takes the number of Julian calendar days since epoch `-4713-11-24T12:00:00` and
returns the corresponding `DateTime` using proleptic Gregorian Calendar.

`jdcnv` is the inverse of this function.
"""
const daycnv=Dates.julian2datetime

"""
    get_date([date::DateTime]) -> ASCIIString

Returns the UTC date in `"CCYY-MM-DD"` format for FITS headers.

The `date` should be a `DateTime` in UTC standard, if omitted it defaults to the
current UTC time.

When no optional keywords (`timetag` and `old`) are supplied, the format of the
output string is `"CCYY-MM-DD"` (year-month-day part of the date), where <CCYY>
represents a 4-digit calendar year, <MM> the 2-digit ordinal number of a
calendar month within the calendar year, and <DD> the 2-digit ordinal number of
a day within the calendar month.

    get_date([date::DateTime;] old=true) -> ASCIIString

If the boolean keyword `old` is true (default: false), the year-month-day part
of date has `"DD/MM/YY"` format.  This is the formerly (pre-1997) recommended
for FITS.  Note that this format is now deprecated because it uses only a
2-digit representation of the year.

    get_date([date::DateTime;] timetag=true) -> ASCIIString

If the boolean keyword `timetag` is true (default: false), `"Thh:mm:ss"` is
appended to the year-month-day part of the date, where <hh> represents the hour
in the day, <mm> the minutes, <ss> the seconds, and the literal 'T' the ISO 8601
time designator.

Note that `old` and `timetag` keywords can be used together, so that the output
string will have `"DD/MM/YYThh:mm:ss"` format.
"""
function get_date(dt::DateTime=Dates.unix2datetime(Libc.time());
                  old::Bool=false, timetag::Bool=false)
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
        return "$(ymds):T$(hh):$(mii):$(ss)"
    else
        return ymds
    end
end

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

"""
    sixty(number::Number) -> [deg::Float64, min::Float64, sec::Float64]

Converts a decimal number to sexagesimal.

This is the reverse of `ten`.
"""
# XXX: trailsign keyword not implemented, not sure it's worth the effort.
# Possible strategy: hold the sign of number in a variable (you can use
# copysign(1, number)), set result[1] equal to dd and multiply the first
# non-zero element (use findfirst for that) by the sign of number.
function sixty(number::Number)
    dd = trunc(abs(number))
    mm = abs(60.0*number)
    ss = abs(3600.0*number)
    result = zeros(Float64, 3)
    result[1] = trunc(number)
    result[2] = trunc(mm - 60.0*dd)
    result[3] = ss - 3600.0*dd - 60.0*result[2]
    return result
end

# TODO: give sense to "-0" ("-0" is bitwise equal to "0").
ten(degrees::Number, minutes::Number=0.0, seconds::Number=0.0) =
    copysign(1, degrees)*(abs(degrees) + minutes/60.0 + seconds/3600.0)
# TODO: improve performance, if possible.  There are a couple of slow tests to
# make parsing of the string work.
function ten(strng::AbstractString)
    # Convert strings into numbers, empty strings into 0s.
    tmp = map(x-> x=="" ? 0 : parse(Float64, x),
              # Replace in the string multiple spaces or colons with a single
              # space and split the string using the space as separator.
              split(replace(strng, r"(\:| )+", s" "), " "))
    # Concatenate "tmp" with 3 zeros, so that "angle" has at least 3 elements
    # also with an empty string in input.
    angle = vcat(tmp, zeros(Float64, 3))
    ten(angle[1], angle[2], angle[3])
end
function ten{T<:Number}(vector::AbstractArray{T,1})
    vect = vcat(vector, zeros(Float64, 2))
    return ten(vect[1], vect[2], vect[3])
end
tenv{D<:Number,M<:Number,S<:Number}(deg::AbstractArray{D},
                                   min::AbstractArray{M}=zeros(Float64, deg),
                                   sec::AbstractArray{S}=zeros(Float64, deg)) =
                                       map(ten, deg, min, sec)
tenv{T<:AbstractString}(strings::AbstractArray{T}) = map(ten, strings)

"""
    ten(deg[, min, sec]) -> Float64
    ten("deg:min:sec") -> Float64
    tenv([deg], [min], [sec]) -> Float64
    tenv(["deg:min:sec"]) -> Float64

Converts a sexagesimal number or string to decimal.

The formula used for the conversion is

    sign(deg)·(|deg| + min/60 + sec/3600))

`ten` requires `deg`, `min`, and `sec` to be all scalars.  Also a one
dimensional array `[deg, min, sec]` is accepted.

The string should have the form `"deg:min:sec"` or `"deg min sec"`.

If minutes and seconds are not specified they default to zero.

`tenv` is the vectorial version of `ten`, it takes as input three numerical
arrays of numbers (minutes and seconds arrays default to null arrays if omitted)
or one array of strings.

`sixty` is the reverse of `ten`.

**NOTE:** These functions cannot deal with `-0` (negative integer zero) in
numeric input.  If it is important to give sense to negative zero, you can
either make sure to pass a floating point negative zero `-0.0` (this is the best
option), or use negative minutes and seconds, or non-integer negative degrees
and minutes.
"""
ten, tenv
