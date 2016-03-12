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
airtovac{T<:Number}(wave_air::AbstractArray{T}) = map(airtovac, wave_air)

"""
    aitoff(l, b) -> (AbstractArray{Float64, N}, AbstractArray{Float64, N})

Takes longitude `l` and latitude `b`, both in degrees, and returns the
corresponding Aitoff coordinates `(x, y)`.  `x` is normalized to be in [-180,
180], `y` is normalized to be in [-90, 90].

Both coordinates may be either a scalar or an array, of the same dimension N,
the output coordinates are always arrays of the same dimension as the input
coordinates (N = 1 when `l` and `b` are scalars).

This function can be used to create an all-sky map in Galactic coordinates with
an equal-area Aitoff projection.  Output map coordinates are zero longitude
centered.

See AIPS memo No. 46
(ftp://ftp.aoc.nrao.edu/pub/software/aips/TEXT/PUBL/AIPSMEMO46.PS), page 4, for
details of the algorithm.  This version of `aitoff` assumes the projection is
centered at b=0 degrees.
"""
# TODO: improve performance, if possible.  Explanation: this function was at
# first defined with scalar only arguments, and then another method added the
# possibility to take vector arguments.  The problem of that approach was that
# the returned argument was an array of tuples, rather than a tuple of arrays.
# However, the current definition (which returns a tuple of arrays, closer to
# original IDL definition), is less efficient then the previous one.
function aitoff{T<:Number}(l::Union{T,AbstractArray{T}},
                           b::Union{T,AbstractArray{T}})
    typeof(l) <: Number && (l = ones(1)*l) # Convert l to a 1D array.
    g = find(x -> x>180.0, l)
    length(g) > 0 && (l[g] = l[g] - 360.0)
    alpha2 = deg2rad(l/2.0)
    delta = deg2rad(b)
    r2 = sqrt(2.0)
    f = 2.0*r2/pi
    cdec = cos(delta)
    denom = sqrt(1.0 .+ cdec.*cos(alpha2))
    x = rad2deg(cdec.*sin(alpha2)*2.*r2./denom/f)
    y = rad2deg(sin(delta)*r2./denom/f)
    return x, y
end

"""
    daycnv(julian_days) -> DateTime

Takes the number of Julian calendar days since epoch `-4713-11-24T12:00:00` and
returns the corresponding `DateTime` using proleptic Gregorian Calendar.

**NOTE:** Before JD = -2299160.5 (that is `1582-10-15T00:00:00`) `daycnv` is
*not* the inverse of `juldate` because the latter adopts Julian Calendar.

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
    juldate(date::DateTime) -> Float64

Takes the given `DateTime` and returns the number of Julian calendar days since
epoch `1858-11-16T12:00:00` (Reduced Julian Date = Julian Date - 2400000) as a
`Float64`.

**NOTE:** Before `1582-10-15T00:00:00` the date is assumed to be in Julian Calendar,
thus before this date `juldate` is *not* the inverse of `daycnv`.
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
