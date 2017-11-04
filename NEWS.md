History of AstroLib.jl
======================

v0.3.0 (2017-1?-??)
-------------------

### Breaking Changes

* `eq2hor` and `hor2eq` now take as mandatory arguments either the name of an
  observatory in `AstroLib.observatories` or the coordinates (latitude,
  longitude and, optionally, altitude) of the observing site.  Keywords `lat`,
  `lon`, `altitude` and `obsname` are no longer accepted.  There is no more a
  default observing site, you always have to provide it.
