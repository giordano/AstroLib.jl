# AstroLib

[![Build Status](https://travis-ci.org/giordano/AstroLib.jl.svg?branch=master)](https://travis-ci.org/giordano/AstroLib.jl)

Goal
----

The aim of this project is to provide users with a set of small generic routines
useful above all in astronomical and astrophysical context.

Included are also translations into Julia language of some
[IDL Astronomy User's Library](http://idlastro.gsfc.nasa.gov/homepage.html)
procedures.  These are not drop-in replacement of those procedures, Julia
standard data types are often used (e.g., `DateTime` type instead of generic
string for dates) and the syntax may slightly differ.  Refer to the
documentation of the functions for details.

**Note:** this project needs help, volounteers are welcome!

Usage
-----

After installing the package, you can start using it with `using AstroLib`.

Here is a summary of exported functions.  For more information about each of
them, like optional arguments and keywords, read their documentation.

<table>
	<tr>
		<td>`daycnv(julian_days)`</td>
		<td>Returns the `DateTime` corresponding to the provided `julian_days` number.</td>
	</tr>
	<tr>
		<td>`get_date(date)`</td>
		<td>Returns the UTC date in `"CCYY-MM-DD"` format for FITS headers.</td>
	</tr>
</table>

Related Projects
----------------

This is not the only effort to bundle astronomical functions written in Julia
language.  Other packages useful for more specific purposes are available at
https://juliaastro.github.io/.

In addition, there is a similar project for Python:
[Python AstroLib](http://www.hs.uni-hamburg.de/DE/Ins/Per/Czesla/PyA/PyA/pyaslDoc/pyasl.html).

License
-------

The AstroLib.jl package is licensed under the MIT "Expat" License.
