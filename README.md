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

**Note:** this project needs help, volunteers are welcome!

Usage
-----

After installing the package, you can start using it with `using AstroLib`.

Here is a summary of exported functions.  For more information about each of
them, like optional arguments and keywords, read their documentation.

<table>
	<tr>
		<td>airtovac(wave_air)</td>
		<td>Convert air wavelengths to vacuum wavelengths.</td>
	</tr>
	<tr>
		<td>aitoff(l, b)</td>
		<td>Convert longitude,latitude to X,Y using Aitoff equal-area projection.</td>
	</tr>
	<tr>
		<td>altaz2hadec(alt, az, lat)</td>
		<td>Convert Horizon (Alt-Az) coordinates to Hour Angle and Declination.</td>
	</tr>
	<tr>
		<td>daycnv(julian_days)</td>
		<td>Returns the DateTime corresponding to the provided julian_days number.</td>
	</tr>
	<tr>
		<td>get_date(date)</td>
		<td>Returns the UTC date in "CCYY-MM-DD" format for FITS headers.</td>
	</tr>
	<tr>
		<td>juldate(date)</td>
		<td>Returns the Reduced Julian Date of provided date.</td>
	</tr>
</table>

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
