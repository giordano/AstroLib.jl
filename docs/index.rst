.. AstroLib.jl documentation master file, created by
   sphinx-quickstart on Tue Mar 15 12:20:54 2016.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

AstroLib.jl
=======================================

`AstroLib.jl <https://github.com/giordano/AstroLib.jl>`__ is a
package of small generic routines useful above all in astronomical and
astrophysical context, written in `Julia <http://julialang.org/>`__.

Included are also translations of some `IDL Astronomy User's
Library <http://idlastro.gsfc.nasa.gov/homepage.html>`__ procedures,
which are released under terms of `BSD-2-Clause
License <http://idlastro.gsfc.nasa.gov/idlfaq.html#A14>`__.
``AstroLib.jl``'s functions are not drop-in replacement of those
procedures, Julia standard data types are often used (e.g., ``DateTime``
type instead of generic string for dates) and the syntax may slightly
differ.

An extensive error testing suite ensures old fixed bugs will not be brought back
by future changes.

Installation
------------

``AstroLib.jl`` is available for Julia 0.4 and later versions, and can
be installed with `Julia built-in package
manager <http://docs.julialang.org/en/stable/manual/packages/>`__. In a
Julia session run the command

.. code:: julia

    julia> Pkg.add("AstroLib")

You may need to update your package list with ``Pkg.update()`` in order
to get the latest version of ``AstroLib.jl``.

Usage
-----

After installing the package, you can start using ``AstroLib.jl`` with

.. code:: julia

    using AstroLib

New Types
---------

Observatory
'''''''''''

``AstroLib.jl`` defines a new ``Observatory`` type. This can be used to define a
new object holding information about an observing site. It is a `composite type
<http://docs.julialang.org/en/stable/manual/types/#composite-types>`__ whose
fields are

- ``name`` (``AbstractString`` type): the name of the site
- ``latitude`` (``Real`` type): North-ward latitude of the site in degrees
- ``longitude`` (``Real`` type): East-ward longitude of the site in degrees
- ``altitude`` (``Real`` type): altitude of the site in meters
- ``tz`` (``Real`` type): the number of hours of offset from UTC

The type constructor ``Observatory`` can be used to create a new
``Observatory`` object. Its syntax is

.. code:: julia

    Observatory(name, lat, long, alt, tz)

``name`` should be a string; ``lat``, ``long``, and ``tz`` should be
anything that can be converted to a floating number with ``ten``
function; ``alt`` should be a real number.

A predefined list of some observing sites is provided with
``AstroLib.observatories`` constant.  It is a dictionary whose keys are the
abbreviated names of the observatories. For example, you can access information
of the European Southern Observatory with

.. code:: julia

    julia> obs = AstroLib.observatories["eso"]
    Observatory: European Southern Observatory
    latitude:    -29.256666666666668°N
    longitude:   -70.73°E
    altitude:    2347.0 m
    time zone:   UTC-4

    julia> obs.longitude
    -70.73

You can list all keys of the dictionary with

.. code:: julia

    keys(AstroLib.observatories)

Feel free to contribute new sites or adjust information of already
present ones.

Planet
''''''

The package provides ``Planet`` type to hold information about Solar
System planets. Its fields are

-  Designation:

   -  ``name``: the name

-  Physical characteristics:

   -  ``radius``: mean radius in meters
   -  ``eqradius``: equatorial radius in meters
   -  ``polradius``: polar radius in meters
   -  ``mass``: mass in kilogram

-  Orbital characteristics (epoch J2000):

   -  ``ecc``: eccentricity of the orbit
   -  ``axis``: semi-major axis of the orbit in meters
   -  ``period``: sidereal orbital period in seconds

The constructor has this syntax:

.. code:: julia

    Planet(name, radius, eqradius, polradius, mass, ecc, axis, period)

The list of Solar System planets, from Mercury to Pluto, is available
with ``AstroLib.planets`` dictionary. The keys this dictionary are the
lowercase names of the planets. For example:

.. code:: julia

    julia> AstroLib.planets["mars"].eqradius
    3.3962e6

    julia> AstroLib.planets["saturn"].mass
    5.6834e25

How Can I Help?
---------------

``AstroLib.jl`` is developed on GitHub at
https://github.com/giordano/AstroLib.jl.  You can contribute to the project in a
number of ways: by translating more routines from IDL Astronomy User's Library,
or providing brand-new functions, or even improving existing ones (make them
faster and more precise).  Also bug reports are encouraged.

License
-------

The ``AstroLib.jl`` package is licensed under the `MIT "Expat" License
<https://opensource.org/licenses/MIT>`__.  The original author is Mosè Giordano.

Notes
-----

This project is a work-in-progress, only few procedures have been
translated so far. In addition, function syntax may change from time to
time. Check
`TODO.md <https://github.com/giordano/AstroLib.jl/blob/master/TODO.md>`__
out to see how you can help. Volunteers are welcome!

Documentation
-------------

Every function provided has detailed documentation that can be
`accessed <http://docs.julialang.org/en/stable/manual/documentation/#accessing-documentation>`__
at Julia REPL with

.. code:: julia

    julia> ?FunctionName

or with

.. code:: julia

    julia> @doc FunctionName

The following is the list of all functions provided to the users.  Click on them
to read their documentation.

Astronomical Utilities
''''''''''''''''''''''

.. toctree::
   :maxdepth: 1

   utils.rst

Miscellaneous (Non-Astronomy) Utilities
'''''''''''''''''''''''''''''''''''''''

.. toctree::
   :maxdepth: 1

   misc.rst

Related Projects
----------------

This is not the only effort to bundle astronomical functions written in Julia
language. Other packages useful for more specific purposes are available at
https://juliaastro.github.io/.  A list of other packages is available `here
<https://github.com/svaksha/Julia.jl/blob/master/Astronomy.md>`__.

Because of this, some of IDL AstroLib's utilities are not provided in
``AstroLib.jl`` as they are already present in other Julia packages.  Here is a
list of such utilities:

- ``aper``, see `AperturePhotometry.jl
  <https://github.com/kbarbary/AperturePhotometry.jl>`__ package
- ``cosmo_param``, see `Cosmology.jl
  <https://github.com/JuliaAstro/Cosmology.jl>`__ package
- ``galage``, see `Cosmology.jl <https://github.com/JuliaAstro/Cosmology.jl>`__
  package
- ``glactc_pm``, see `SkyCoords.jl <https://github.com/kbarbary/SkyCoords.jl>`__
  package
- ``glactc``, see `SkyCoords.jl <https://github.com/kbarbary/SkyCoords.jl>`__
  package
- ``jplephinterp``, see `JPLEphemeris.jl
  <https://github.com/helgee/JPLEphemeris.jl>`__ package
- ``jplephread``, see `JPLEphemeris.jl
  <https://github.com/helgee/JPLEphemeris.jl>`__ package
- ``jplephtest``, see `JPLEphemeris.jl
  <https://github.com/helgee/JPLEphemeris.jl>`__ package
- ``lumdist``, see `Cosmology.jl <https://github.com/JuliaAstro/Cosmology.jl>`__
  package
- ``readcol``, use `readdlm
  <http://docs.julialang.org/en/stable/stdlib/io-network/#Base.readdlm>`__, part
  of Julia ``Base.DataFmt`` module.  This is not a complete replacement for
  ``readcol`` but most of the time it does-the-right-thing even without using
  any option (it automatically identifies string and numerical columns) and you
  do not need to manually specify a variable for each column

In addition, there are similar projects for Python (`Python AstroLib
<http://www.hs.uni-hamburg.de/DE/Ins/Per/Czesla/PyA/PyA/pyaslDoc/pyasl.html>`__)
and R (`Astronomy Users Library
<http://rpackages.ianhowson.com/cran/astrolibR/>`__).

Indices and tables
==================

* :ref:`genindex`
