using AstroLib
using Base.Test

@test AstroLib.daycnv(2440000.0) == DateTime(1968, 05, 23, 12)

@test AstroLib.get_date(DateTime(2001,09,25,14,56,14), old=true,timetag=true) == "25/09/2001:T14:56:14"
