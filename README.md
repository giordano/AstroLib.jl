# AstroLib

[![Travis Build Status](https://travis-ci.org/giordano/AstroLib.jl.svg?branch=master)](https://travis-ci.org/giordano/AstroLib.jl)
[![Appveyor Build Status](https://ci.appveyor.com/api/projects/status/jfa9e54lv92rqd3m?svg=true)](https://ci.appveyor.com/project/giordano/astrolib-jl)


Goal
----

The aim of this project is to provide users with a set of small generic routines
useful above all in astronomical and astrophysical context, written in
[Julia](http://julialang.org/).

Included are also translations of some
[IDL Astronomy User's Library](http://idlastro.gsfc.nasa.gov/homepage.html)
procedures, which are released under terms of
[BSD-2-Clause License](http://idlastro.gsfc.nasa.gov/idlfaq.html#A14).
AstroLib.jl's functions are not drop-in replacement of those procedures, Julia
standard data types are often used (e.g., `DateTime` type instead of generic
string for dates) and the syntax may slightly differ.  Refer to the
documentation of the functions for details.

**Note:** this project is a work-in-progress, only few procedures have been
translated so far.  In addition, function syntax may change from time to time.
Check [TODO.md](https://github.com/giordano/AstroLib.jl/blob/master/TODO.md) out
to see how you can help.  Volunteers are welcome!

Install
------------

`AstroLib.jl` is available for Julia 0.4 and later versions, and can be
installed with
[Julia built-in package manager](http://docs.julialang.org/en/stable/manual/packages/).
In a Julia session run the command

```julia
julia> Pkg.add("AstroLib")
```

Usage
-----

After installing the package, you can start using it with

```julia
using AstroLib
```

Here is a summary of functions exposed to the users.  For more information about
each of them, like optional arguments and keywords, read their documentation.

### `utils.jl` ###

Function | Purpose
-------- | -------
`airtovac(wave_air)` | Convert air wavelengths to vacuum wavelengths
`aitoff(l, b)` | Convert longitude,latitude to X,Y using Aitoff equal-area projection.
`altaz2hadec(alt, az, lat)` | Convert Horizon (Alt-Az) coordinates to Hour Angle and Declination.
`daycnv(julian_days)` | Returns the Gregorian DateTime corresponding to the provided `julian_days` number.
`calz_unred(wave, flux, ebv, r_v)` | Deredden a galaxy spectrum using the Calzetti et al. (2000) parameterization.
`get_date(date)` | Returns the UTC date in "CCYY-MM-DD" format for FITS headers.
`get_juldate(date)` | Get the current Julian date as a double precision scalar.
`jdcnv(date)` | Convert from Gregorian calendar date to Julian date.
`juldate(date)` | Returns the Reduced Julian Date of provided date.
`radec(ra, dec)` | Format right ascension and declination as hours, min, sec, deg, min, sec
`sixty(number)` | Converts a decimal number to sexagesimal.
`ten(hours, minutes, seconds)` | Convert sexigesimal number to decimal.
`tenv([hours], [minutes], [seconds])` | Convert arrays of sexigesimal numbers to decimal.

### `misc.jl` ###

Function | Purpose
-------- | -------
`cirrange(angle)` | Force an angle to be in the range [0, 360), or [0, 2\pi).

Related Projects
----------------

This is not the only effort to bundle astronomical functions written in Julia
language.  Other packages useful for more specific purposes are available at
https://juliaastro.github.io/.

In addition, there are similar projects for Python
([Python AstroLib](http://www.hs.uni-hamburg.de/DE/Ins/Per/Czesla/PyA/PyA/pyaslDoc/pyasl.html))
and R
([Astronomy Users Library](http://rpackages.ianhowson.com/cran/astrolibR/)).

License
-------

The AstroLib.jl package is licensed under the MIT "Expat" License.  The original
author is Mosè Giordano.
