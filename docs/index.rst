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

Development
-----------

``AstroLib.jl`` is developed on GitHub at
https://github.com/giordano/AstroLib.jl. You can contribute by providing
new functions, reporting bugs, and improving documentation.

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
