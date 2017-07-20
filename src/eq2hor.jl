# This file is a part of AstroLib.jl. License is MIT "Expat".

function _eq2hor(ra::T, dec::T, jd::T, lat::T, lon::T, altitude::T,
                 pressure::T, temperature::T, ws::Bool, B1950::Bool,
                 precession::Bool, nutate::Bool, aberration::Bool,
                 refract::Bool,obsname::AbstractString) where {T<:AbstractFloat}

    if obsname == ""
        # Using Pine Bluff Observatory values
        if isnan(lat)
            lat = T(43.0783)
        end

        if isnan(lon)
            lon = T(-89.865)
        end
    else
        lat = T(observatories[obsname].latitude)
        lon = T(observatories[obsname].longitude)
        altitude = T(observatories[obsname].altitude)
    end
    j_now = (jd - J2000) / JULIANYEAR + 2000

    if precession
        if B1950
            ra, dec = precess(ra, dec, j_now, 1950, FK4=true)
        else
            ra, dec = precess(ra, dec, j_now, 2000)
        end
    end
    dra1, ddec1, eps, d_psi = co_nutate(jd, ra, dec)

    if nutate
       ra += dra1
       dec += ddec1
    end

    if aberration
        dra2, ddec2 = co_aberration(jd, ra, dec, eps)
        ra += dra2 / 3600
        dec += ddec2 / 3600
    end
    last = 15 * ct2lst(lon, jd) + d_psi * cos(eps) / 3600
    ha = mod(last - ra, 360)
    alt, az = hadec2altaz(ha, dec, lat, ws=ws)

    if refract
        alt = co_refract(alt, altitude, pressure, temperature)
    end
    return alt, az, ha
end

"""
    eq2hor(ra, dec, jd[, ws=false, B1950=false, precession=true, nutate=true,
           aberration=true, refract=true, lat=NaN, lon=NaN, altitude=0, pressure=NaN,
           temperature=NaN, obsname="") -> alt, az, ha

### Purpose ###

Convert celestial  (ra-dec) coords to local horizon coords (alt-az).

### Explanation ###

This code calculates horizon (alt,az) coordinates from equatorial (ra,dec) coords.
It performs precession, nutation, aberration, and refraction corrections.

### Arguments ###

* `ra`: right ascension of object, in degrees
* `dec`: declination of object, in degrees
* `jd`: julian date
* `ws` (optional boolean keyword): set this to `true` to get the azimuth measured
* `B1950` (optional boolean keyword): set this to `true` if the ra and dec
  are specified in B1950 (FK4 coordinates) instead of J2000 (FK5). This is `false` by
  default
* `precession` (optional boolean keyword): set this to `false` for no precession
  correction, `true` by default
* `nutate` (optional boolean keyword): set this to `false` for no nutation,
  `true` by default
* `aberration` (optional boolean keyword): set this to `false` for no aberration
  correction, `true` by default
* `refract` (optional boolean keyword): set this to `false` for no refraction
  correction, `true` by default
* `lat` (optional keyword): north geodetic latitude of location, in degrees. Default
  is `NaN`
* `lon` (optional keyword): AST longitude of location, in degrees. You can specify west
  longitude with a negative sign. Default value is `NaN`
* `altitude` (optional keyword): the altitude of the observing location, in meters.
  It is `0` by default
* `pressure` (optional keyword): the pressure at the observing location, in millibars.
  Default value is `NaN`
* `temperature` (optional keyword): the temperature at the observing location, in Kelvins.
  Default value is `NaN`
* `obsname` (optional keyword): set this to a valid observatory name to
  be used by the [Observatory](@ref) type, which will return the latitude and
  longitude to be used by this program. This is `""` (empty string) by default,
  in which case `lat` and `lon` default to the coordinates of the `Pine Bluff Observatory`
  provided they are equivalent to `NaN` individually

### Output ###

* `alt`: altitude of horizon coords, in degrees
* `az`: azimuth angle measured East from North (unless ws is `true`), in degrees
* `ha`: hour angle, in degrees

### Example ###

```jldoctest
julia> using AstroLib

julia> alt_o, az_o = eq2hor(ten(6,40,58.2)*15, ten(9,53,44), 2460107.25, lat=ten(50,31,36),
                                   lon=ten(6,51,18), altitude=369, pressure = 980, temperature=283)
(16.040966354652365, 266.1447829865725, 76.7608239877382)

julia> adstring(az_o, alt_o)
" 17 44 34.7  +16 02 27"
```

### Notes ###

Code of this function is based on IDL Astronomy User's Library.
"""
eq2hor(ra::Real, dec::Real, jd::Real; ws::Bool=false, B1950::Bool=false,
       precession::Bool=true, nutate::Bool=true, aberration::Bool=true,
       refract::Bool=true, lat::Real=NaN, lon::Real=NaN, altitude::Real=0,
       pressure::Real=NaN, temperature::Real=NaN, obsname::AbstractString="") =
           _eq2hor(promote(float(ra), float(dec), float(jd), float(lat), float(lon),
                   float(altitude), float(temperature), float(pressure))..., ws, B1950,
                   precession, nutate, aberration, refract, obsname)
# TODO: Make eq2hor type-stable, which it isn't currently because of keyword arguments
# Note that the inner function `_eq2hor` is type stable