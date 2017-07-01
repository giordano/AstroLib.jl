# This file is a part of AstroLib.jl. License is MIT "Expat".

function _hor2eq(alt::T, az::T, jd::T, lat::T, lon::T, altitude::T, pressure::T,
                 temperature::T, obsname::AbstractString, ws::Bool, B1950::Bool,
                 precession::Bool, nutate::Bool, aberration::Bool,
                 refract::Bool) where {T<:AbstractFloat}

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
        lon = one(T) * observatories[obsname].longitude
        altitude = T(observatories[obsname].altitude)
    end

    if refract
        alt_b = co_refract(alt, altitude, pressure, temperature)
    else
        alt_b = alt
    end

    if ws
        az -= 180
    end
    dra1, ddec1, eps, d_psi, _ = co_nutate(jd, 45, 45)
    last = 15 * ct2lst(lon, jd) + d_psi * cos(eps) / 3600
    ha, dec = altaz2hadec(alt_b, az, lat)
    ra = mod(last - ha, 360)
    dra1, ddec1, eps, _, _ = co_nutate(jd, ra, dec)
    dra2, ddec2 = co_aberration(jd, ra, dec, eps)

    if nutate
       ra -= dra1
       dec -= ddec1
    end

    if aberration
        ra -= dra2 / 3600
        dec -= ddec2 / 3600
    end
    j_now = (jd - J2000) / JULIANYEAR + 2000

    if precession

        if B1950
            ra_o, dec_o = precess(ra, dec, j_now, 1950, FK4=true)
        else
            ra_o, dec_o = precess(ra, dec, j_now, 2000)
        end
    else
        ra_o = ra
        dec_o = dec
    end
    return ra_o, dec_o, ha
end
"""


### Purpose ###

Converts local horizon coordinates (alt-az) to equatorial (ra-dec) coordinates.

### Explanation ###

This is a function to calculate equatorial (ra,dec) coordinates from
horizon (alt,az) coords. It is accurate to about 1 arcsecond or better.
It performs precession, nutation, aberration, and refraction corrections.

### Arguments ###

* `alt`: altitude of horizon coords, in degrees
* `az`: azimuth angle measured East from North (unless ws is `true`), in degrees
* `jd`: julian date
* `lat` (optional keyword): north geodetic latitude of location, in degrees. Default
  is NaN
* `lon` (optional keyword): AST longitude of location, in degrees. You can specify west
  longitude with a negative sign. Dafault is NaN.
* `altitude` (optional keyword): the altitude of the observing location, in meters.
  It it zero by default
* `pressure` (optional keyword): the pressure at the observing location, in millibars.
  Default is NaN
* `temperature` (optional keyword): the temperature at the observing location, in Kelvins.
  Default is NaN
* `obsname` (optional keyword): set this to a valid observatory name to
  be used by the observatory type in [types](@ref), which will return
  the latitude and longitude to be used by this program. Default is NaN.
* `ws` (optional boolean keyword): set this to `true` to get the azimuth measured
  westward from south
* `B1950` (optional boolean keyword): Set this to `true` if the ra and dec
  are specified in B1950 (FK4 coordinates) instead of J2000 (FK5)
* `precession` (optional boolean keyword): set this to `false` for no precession,
  `true` by default
* `nutate` (optional boolean keyword): set this to `false` for no nutation,
  `true` by default
* `aberration` (optional boolean keyword): set this to `false` for no aberration
  correction, `true` by default
* `refract` (optional boolean keyword): set this to `false` for no refraction
  correction, `true` by default

### Output ###

* `ra`: right ascension of object, in degrees (FK5)
* `dec`: declination of the object, in degrees (FK5)
* `ha`: hour angle, in degrees

### Example ###

```jldoctest

```

### Notes ###

Code of this function is based on IDL Astronomy User's Library.
"""
hor2eq(alt::Real, az::Real, jd::Real; lat::Real=NaN, lon::Real=NaN, altitude::Real=0,
       pressure::Real=NaN, temperature::Real=NaN, obsname::AbstractString="",
       ws::Bool=false, B1950::Bool=false, precession::Bool=true, nutate::Bool=true,
       aberration::Bool=true, refract::Bool=true) =
           _hor2eq(promote(float(alt), float(az), float(jd), float(lat), float(lon),
                   float(altitude), float(temperature), float(pressure))..., obsname,
                   ws, B1950, precession, nutate, aberration, refract)
