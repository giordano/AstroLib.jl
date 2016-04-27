# AstroLib

[![Travis Build Status on GNU/Linux and OS X](https://travis-ci.org/giordano/AstroLib.jl.svg?branch=master)](https://travis-ci.org/giordano/AstroLib.jl) [![Appveyor Build Status on Windows](https://ci.appveyor.com/api/projects/status/jfa9e54lv92rqd3m?svg=true)](https://ci.appveyor.com/project/giordano/astrolib-jl) [![Coverage Status](https://coveralls.io/repos/github/giordano/AstroLib.jl/badge.svg?branch=master)](https://coveralls.io/github/giordano/AstroLib.jl?branch=master) [![codecov.io](https://codecov.io/github/giordano/AstroLib.jl/coverage.svg?branch=master)](https://codecov.io/github/giordano/AstroLib.jl?branch=master) [![AstroLib](http://pkg.julialang.org/badges/AstroLib_0.4.svg)](http://pkg.julialang.org/?pkg=AstroLib) [![AstroLib](http://pkg.julialang.org/badges/AstroLib_0.5.svg)](http://pkg.julialang.org/?pkg=AstroLib)

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

Installation
------------

`AstroLib.jl` is available for Julia 0.4 and later versions, and can be
installed with
[Julia built-in package manager](http://docs.julialang.org/en/stable/manual/packages/).
In a Julia session run the command

```julia
julia> Pkg.add("AstroLib")
```

You may need to update your package list with `Pkg.update()` in order to get the
latest version of `AstroLib.jl`.

Usage
-----

After installing the package, you can start using it with

```julia
using AstroLib
```

Documentation
-------------

Every function provided has detailed documentation that can be
[accessed](http://docs.julialang.org/en/stable/manual/documentation/#accessing-documentation)
at Julia REPL with

``` julia
julia> ?FunctionName
```

or with

``` julia
julia> @doc FunctionName
```

Full documentation of all functions can be accessed at
https://astrolibjl.readthedocs.org/.  There you can find the complete list of
all functions provided by this library.  You can also download the manual in PDF
format from https://media.readthedocs.org/pdf/astrolibjl/latest/astrolibjl.pdf.

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
