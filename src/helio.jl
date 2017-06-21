# This file is a part of AstroLib.jl. License is MIT "Expat".

function _helio(jd::T, num::Integer, radian::Bool) where {T<:AbstractFloat}
    # dpd gives the time rate of change of the mean orbital quantities
    # dpd elements taken from https://ssd.jpl.nasa.gov/txt/p_elem_t1.txt
    dpd = [ 0.00000037  0.00001906 -0.00594749  -0.12534081   0.16047689 149472.67411175 ;
            0.00000390 -0.00004107 -0.00078890  -0.27769418   0.00268329  58517.81538729 ;
            0.00000562 -0.00004392 -0.01294668   0.0          0.32327364  35999.37244981 ;
            0.00001847  0.00007882 -0.00813131  -0.29257343   0.44441088  19140.30268499 ;
           -0.00011607 -0.00013253 -0.00183714   0.20469106   0.21252668   3034.74612775 ;
           -0.00125060 -0.00050991  0.00193609  -0.28867794  -0.41897216   1222.49362201 ;
           -0.00196176 -0.00004397 -0.00242939   0.04240589   0.40805281    428.48202785 ;
            0.00026291  0.00005105  0.00035372  -0.00508664  -0.32241464    218.45945325 ;
           -0.00031596  0.00005170  0.00004818  -0.01183482  -0.04062942    145.20780515 ]

    if num<1 || num>9
        error("Input should be an integer in the range 1:9 denoting planet number")
    end
    t = (jd - J2000) / (JULIANYEAR * 100)
    record = Dict(1=>"mercury", 2=>"venus", 3=>"earth", 4=>"mars", 5=>"jupiter",
                  6=>"saturn", 7=>"uranus", 8=>"neptune", 9=>"pluto")
    body = record[num]
    dpd *= t
    a = planets[body].axis/AU + dpd[num, 1]
    eccen = planets[body].ecc + dpd[num, 2]
    n = deg2rad(0.9856076686 / (a * sqrt(a) ))
    inc = deg2rad(planets[body].inc + dpd[num, 3])
    along = deg2rad(planets[body].asc_long + dpd[num, 4])
    plong = deg2rad(planets[body].per_long + dpd[num, 5])
    mlong = deg2rad(planets[body].mean_long + dpd[num, 6])
    m = cirrange(mlong - plong, 2*pi)
    e1 = m + ((eccen * sin(m) - m)/ (1 - eccen*cos(m)))
    e = e1 + ((m + eccen * sin(m) - e1)/ (1 - eccen*cos(e1)))
    maxdiff = abs(e - e1)
    niter = 0

    while maxdiff> 1e-5 && niter<10
        e1 = e
        e = e1 + ((m + eccen * sin(m) - e1)/ (1 - eccen*cos(e1)))
        maxdiff = abs(e-e1)
        niter += 1
    end
    nu = 2 * atan(sqrt((1 + eccen)/(1 - eccen)) * tan(e/2))
    hrad = a * (1 - eccen * cos(e))
    hlong = cirrange(nu + plong, 2 * pi)
    hlat = asin(sin(hlong - along) * sin(inc))
    if radian
        return hrad, hlong, hlat
    end
    return hrad, rad2deg(hlong), rad2deg(hlat)
end

"""
    helio(jd, list[, radian=true]) -> hrad, hlong, hlat

### Purpose ###

Compute heliocentric coordinates for the planets.

### Explanation ###

The mean orbital elements for epoch J2000 are used. These are derived
from a 250 yr least squares fit of the DE 200 planetary ephemeris to a
Keplerian orbit where each element is allowed to vary linearly with
time. Useful mainly for dates between 1800 and 2050, this solution fits the
terrestrial planet orbits to ~25'' or better, but achieves only ~600''
for Saturn.

### Arguments ###

* `jd`: julian date, scalar or vector
* `num`: integer denoting planet number, scalar or vector
  1 = Mercury, 2 = Venus, ... 9 = Pluto
* `radian`(optional boolean keyword): if this keyword is set to
  `true`, than the longitude and latitude output are in radian rather than degrees.

### Output ###

* `hrad`: the heliocentric radii in astronomical units,
* `hlong`: the heliocentric (ecliptic) longitudes, in degrees
* `hlat`: the heliocentric latitudes in degrees.

### Example ###

```julia

```

### Notes ###

This program is based on the two-body model and thus neglects
interactions between the planets. This is why the worst results
are for Saturn.

The coordinates are given for equinox 2000 and *not* the equinox
of the supplied date.

Code of this function is based on IDL Astronomy User's Library.
"""
helio(jd::Real, num::Integer, radian::Bool=false) =
    _helio(promote(float(jd))..., num, radian)

function helio(jd::AbstractVector{P}, num::AbstractVector{Q},
               radian::Bool = false) where {P<:Real, Q<:Real}
    @assert length(jd) == length(num) "jd and num vectors should
                                       be of the same length"
    typejd = float(P)
    hrad_out = similar(jd,  typejd)
    hlong_out = similar(jd,  typejd)
    hlat_out = similar(jd,  typejd)
    for i in eachindex(jd)
        hrad_out[i], hlong_out[i], hlat_out[i] =
        helio(jd[i], num[i], radian)
    end
    return hrad_out, hlong_out, hlat_out
end
