# This file is a part of AstroLib.jl. License is MIT "Expat".

#TODO: Use full JPL ephemeris for high precision
function _planet_coords(date::T, num::Integer) where {T<:AbstractFloat}

    if num<1 || num>9
        error("Input should be an integer in the range 1:9 denoting planet number")
    end
    rad, long, lat = helio(date, num, true)
    rade, longe, late = helio(date, 3, true)
    x =  rad * cos(lat) * cos(long) - rade * cos(late) * cos(longe)
    y = rad * cos(lat) * sin(long) - rade * cos(late) * sin(longe)
    z = rad * sin(lat) - rade * sin(late)
    lamda = rad2deg(atan2(y,x))
    beta = rad2deg(atan2(z, hypot(x,y)))
    ra, dec = euler(lamda, beta, 4)
    return ra, dec
end

"""
    planet_coords()

### Purpose ###

Find right ascension and declination for the planets when provided a date as input.

### Explanation ###

This function uses the [`helio`](@ref) to get the heliocentric ecliptic coordinates of the
planets at the given date which it then converts these to geocentric ecliptic
coordinates ala "Astronomical Algorithms" by Jean Meeus (1991, p 209).
These are then converted to right ascension and declination using [`euler`](@ref).

The accuracy between the years 1800 and 2050 is better than 1 arcminute for the
terrestial planets, but reaches 10 arcminutes for Saturn. Before 1850 or after 2050
the accuracy can get much worse.

### Arguments ###

* `date`: Can be either a single date or an array of dates. Each element can be
  either a `DateTime` type or Julian Date. It can be a scalar or vector.
* `num`: integer denoting planet number, scalar or vector
  1 = Mercury, 2 = Venus, ... 9 = Pluto. If not in that change, then the
  program will throw an error.

### Output ###

* `ra`: right ascension of planet(J2000), in degrees
* `dec`: declination of the planet(J2000), in degrees

### Example ###

Find the RA, Dec of Venus on 1992 Dec 20

```jldoctest
julia> using AstroLib

julia> adstring(planet_coords(DateTime(1992,12,20),2))
" 21 00 15.3  -19 09 09"
```

### Notes ###

Code of this function is based on IDL Astronomy User's Library.
"""
planet_coords(date::Real, num::Integer) = _planet_coords(float(date), num)

function planet_coords(date::AbstractVector{R},
                       num::AbstractVector{<:Integer}) where {R<:Real}
    @assert length(date) == length(num) "date and num arrays should be of the same length"
    typedate = float(R)
    ra_out  = similar(date, typedate)
    dec_out = similar(date, typedate)
    for i in eachindex(date)
        ra_out[i], dec_out[i] = planet_coords(date[i], num[i])
    end
    return ra_out, dec_out
end

planet_coords(date::DateTime, num::Integer) = planet_coords(jdcnv(date), num)
