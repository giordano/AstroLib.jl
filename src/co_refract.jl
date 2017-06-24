# This file is a part of AstroLib.jl. License is MIT "Expat".

function _co_nutate(old_alt::T, altitude::T, pressure::T, temperature::T,
                    epsilon::T, to_observe::Bool)
    if isnan(temperature)

end

"""
    co_refract(old_alt[, altitude=0, pressure=NaN, temperature=NaN,
               epsilon=0.25, to_observe=false]) -> new_alt

### Purpose ###

Calculate correction to altitude due to atmospheric refraction.

### Explanation ##

Because the index of refraction of air is not precisely 1.0, the atmosphere
bends all incoming light, making a star or other celestial object appear at
a slightly different altitude (or elevation) than it really is.  It is
important to understand the following definitions:

* Observed Altitude: The altitude that a star is seen to be, with a telescope.
  This is where it appears in the sky. This is should be always greater than the
  apparent altitude.

* Apparent Altitude: The altitude that a star would be at, if ~there were no
  atmosphere~ (sometimes called the "true" altitude). This is usually calculated
  from an object's celestial coordinates. Apparent altitude should always be
  smaller than the observed altitude.

Thus, for example, the Sun's apparent altitude when you see it right on the
horizon is actually -34 arcminutes.

This program uses a couple of simple formulae to estimate the effect for most
optical and radio wavelengths. Typically, you know your observed altitude
(from an observation), and want the apparent altitude. To go the other way,
this program uses an iterative approach.

### Arguments ###

* `old_apt`: observed altitude in degrees. If `to_observe` is set to true,
  this should be apparent altitude
* `altitude` (optional): the height of the observing location, in meters. This is
  only used to determine an approximate temperature and pressure, if these are not
  specified separately. Default is 0 i.e. sea level
* `pressure` (optional): the pressure at the observing location, in millibars.
  Default is NaN
* `temperature` (optional): the temperature at the observing location, in Kelvins.
  Default is NaN
* `epsilon` (optional): the accuracy to obtain, in arcseconds. If `to_observe` is
  true, then it will be calculated. Default is 0.25 arcseconds
* `to_observe` (optional boolean keyword): if set to true, it is assumed that `old_alt`
  has apparent altitude as its input and the observed altitude will be found

### Output ###

* `new_alt`: apparent alititude, in degrees. Observed altitude is returned if `to_observe`
  is set to true

### Example ###

```jldoctest

```

### Notes ###

If altitude is set, but temperature or pressure are not, the program will make an
intelligent guess for the temperature and pressure.

#### Wavelength Dependence ####

This correction is 0 at zenith, about 1 arcminute at 45 degrees, and 34 arcminutes at the
horizon for optical wavelengths. The correction is non-negligible at all wavelengths,
but is not very easily calculable.
These formulae assume a wavelength of 550 nm, and will be accurate to about 4 arcseconds
for all visible wavelengths, for elevations of 10 degrees and higher.
Amazingly, they are also accurate for radio frequencies less than ~ 100 GHz.

#### References ####

* Meeus, Astronomical Algorithms, Chapter 15.
* Explanatory Supplement to the Astronomical Almanac, 1992.
* Methods of Experimental Physics, Vol 12 Part B, Astrophysics, Radio Telescopes, Chapter 2.5,
  "Refraction Effects in the Neutral Atmosphere", by R.K. Crane.

Code of this function is based on IDL Astronomy User's Library.
"""