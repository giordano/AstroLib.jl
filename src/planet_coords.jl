# This file is a part of AstroLib.jl. License is MIT "Expat".

#TODO: Use full JPL ephemeris for high precision
function _planet_coords(date::T, planet::Integer, jd::Bool) where {T<:AbstractFloat}

    if !jd
        date = jdcnv(date)
    end

    if planet == 0
        _planet_coords.(date, [1,2,4,5,6,7,8,9], true)
    else
        rad, long, lat = helio(date, planet, true)
        rade, longe, late = helio(date, 3, true)
        x =  rad * cos(lat) * cos(long) - rade * cos(late) * cos(longe)
        y = rad * cos(lat) * sin(long) - rade * cos(late) * sin(longe)
        z = rad * sin(lat) - rade * sin(late)
        lamda = rad2deg(atan2(y,x))
        beta = rad2deg(atan2(z, hypot(x,y)))
        ra, dec = euler(lamda, beta, 4)
        return ra, dec
    end
end

"""
    planet_coords()

### Purpose ###

Find right ascension and declination for the planets when provided a date as input.

### Explanation ###

This function uses the [helio](@ref) to get the heliocentric ecliptic coordinates of the
planets at the given date which it then converts these to geocentric ecliptic
coordinates ala "Astronomical Algorithms" by Jean Meeus (1991, p 209).
These are then converted to right ascension and declination using [euler](@ref).

The accuracy between the years 1800 and 2050 is better than 1 arcminute for the
terrestial planets, but reaches 10 arcminutes for Saturn. Before 1850 or after 2050
the accuracy can get much worse.

### Arguments ###

* `date`: Can be either a single date or an array of dates. Each element can be
  either a `DateTime` type or anything that can be converted directly to `DateTime`.
  In the case of vectorial input, each element is considered as a date, so you
  cannot provide a date by parts
* `num`(optional): integer denoting planet number, scalar or vector
  1 = Mercury, 2 = Venus, ... 9 = Pluto. If not given or is 0, then the
  coordinates of every planet except earth will be computed
* `jd`(optional boolean keyword): if set to `true`, then the date parameter should
  be supplied as as Julian Date. It is `false` by default

### Output ###

* `ra`: right ascension of planet(J2000), in degrees
* `dec`: declination of the planet(J2000), in degrees

### Example ###

```jldoctest

```

### Notes ###

Code of this function is based on IDL Astronomy User's Library.
"""
planet_coords(date::Real, planet::Integer=0; jd::Bool=false) =
    _planet_coords(float(date), planet, jd)

function planet_coords(date::AbstractVector{R}, planet::AbstractVector{<:Real}=0;
                       jd::Bool=false) where {R<:Real}
    @assert length(date) == length(planet) "date and planet arrays should be of the same length"
    typedate = float(R)
    ra_out  = similar(date,  typedate)
    dec_out = similar(date, typedate)
    for i in eachindex(date)
        ra_out[i], dec_out[i] = planet_coords(date[i], planet[i], jd=jd)
    end
    return ra_out, dec_out
end