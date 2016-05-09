# This file is a part of AstroLib.jl. License is MIT "Expat".
# Copyright (C) 2016 Mosè Giordano.

# Test adstring
@test adstring((30.4, -1.23), truncate=true) ==
    adstring([30.4, -1.23], truncate=true) == " 02 01 35.9  -01 13 48"
@test adstring(19.19321, truncate=true) == "+19 11 35.5"
@test adstring(ten(36,24,15.015), -ten(8,24,36.0428), precision=3) ==
    " 02 25 37.0010  -08 24 36.043"
@test adstring([30.4, -15.63], [-1.23, 48.41], precision=2) ==
    [" 02 01 36.000  -01 13 48.00", " 22 57 28.800  +48 24 36.00"]
@test adstring([(-58, 724)]) == [" 20 08 00.0  +724 00 00"]

# Test airtovac
@test_approx_eq airtovac([1234 6056.125]) [1234.0 6057.801930991426]
@test_approx_eq airtovac(2100) 2100.666421596007

# Test aitoff
@test aitoff([227.23, 130], [-8.890, -35]) ==
    ([-137.92196683723276, 115.17541338020645], [-11.772527357473054, -44.491889962090085])
@test aitoff([375], [2.437]) ==
    ([16.63760711611838],[2.712427279646118])
@test aitoff((227.23, -8.890)) ==
    (-137.92196683723276,-11.772527357473054)

# Test altaz2hadec
@test altaz2hadec(59.086111, 133.30806, 43.07833) ==
    altaz2hadec((59.086111, 133.30806), 43.07833) ==
    (336.68286017949157, 19.182449588316555)
@test altaz2hadec([15, 25, 35],
                  [25.12, 45.32, -20.3],
                  [-23.44, 45.0, 52.5]) ==
                      ([324.9881067314537, 256.7468302330436, 132.4919217875949],
                       [44.38225395397647, 48.542947077386664, 67.33061196497327])

# Test bprecess
let
    local ra, dec
    ra, dec = bprecess([ten(13, 42, 12.74)*15], [ten(8, 23, 17.69)],
                       reshape(100*[-15*0.0257, -0.090], 2, 1))
    @test_approx_eq ra  204.93552515632123
    @test_approx_eq dec 8.641287183886163
    ra, dec = bprecess([57], [23], 2024)
    @test_approx_eq ra  56.26105898810067
    @test_approx_eq dec 22.84693298145991
    ra, dec = bprecess([57], [23], reshape([9, 86], 2, 1), parallax=[1], radvel=[4])
    @test_approx_eq ra  56.25988479854577
    @test_approx_eq dec 22.83493370392355
    ra, dec = bprecess((-57, -23), 2024)
    @test_approx_eq ra   302.2593299643789
    @test_approx_eq dec -23.150089972802036
    ra, dec = bprecess((-57, -23), [9, 86], parallax=1, radvel=4)
    @test_approx_eq ra   302.2580376402947
    @test_approx_eq dec -23.16208183899836
end

# Test calz_unred
@test_approx_eq calz_unred(reshape(900:1000:9900, 10, 1), ones(Float64, 10), -0.1) [1.0,                0.43189326452379095,
                                                                                    0.5203675483533704, 0.594996469192435,
                                                                                    0.6569506252451913, 0.7080829505773865,
                                                                                    0.7502392743978797, 0.7861262388745882,
                                                                                    0.8151258710444882, 0.8390325371659836]

#test ct2lst
@test_approx_eq ct2lst(-76.72, -4, [DateTime(2008, 7, 30, 15, 53)]) [11.356505172312609]
@test_approx_eq ct2lst(9, [jdcnv(DateTime(2015, 11, 24, 12, 21))]) [17.159574059885927]

# Test daycnv with Gregorian Calendar in force.
@test daycnv(2440000.0) == DateTime(1968, 05, 23, 12)
# Test daycnv with Julian Calendar in force (same result as IDL AstroLib's
# daycnv).
@test daycnv(2000000.0) == DateTime(763, 09, 18, 12)
@test daycnv(0.0) == DateTime(-4713, 11, 24, 12)

# Test deredd
let
    local by0, m0, c0, ub0
    by0, m0, c0, ub0 = deredd([0.5, -0.5], [0.2, 0.5], [1, 1], [1, 1], [0.1, 0.3])
    @test_approx_eq by0 [-0.3,0.5]
    @test_approx_eq m0  [1.165,1.0]
    @test_approx_eq c0  [0.905,1.0]
    @test_approx_eq ub0 [-0.665,0.3]
end


# Test eci2geo
let
    local lat, long, alt, jd
    lat, long, alt = eci2geo([0], [0], [0], [2452343])
    @test_approx_eq lat  [0]
    @test_approx_eq long [12.992783145436988]
    @test_approx_eq alt  [-6378.137]
    lat, long, alt = eci2geo((6978.137, 0, 0), jdcnv(DateTime("2015-06-30T14:03:12.857")))
    @test_approx_eq lat  0
    @test_approx_eq long 230.87301833205856
    @test_approx_eq alt  600
    # Test `eci2geo' is the inverse of `geo2eci'
    jd = get_juldate()
    lat, long, alt = eci2geo(geo2eci(10, 10, 10, jd), jd)
    @test_approx_eq lat  10
    @test_approx_eq long 10
    @test_approx_eq alt  10
end

# Test eqpole
let
    local x, y
    x, y = eqpole([100], [35], southpole=true)
    @test_approx_eq x [-111.18287262822456]
    @test_approx_eq y [ -19.604540237028665]
    x, y = eqpole([80], [19])
    @test_approx_eq x [72.78853915267848]
    @test_approx_eq y [12.83458333897169]
end

# Test flux2mag
@test_approx_eq flux2mag([1.5e-12, 8.7e-15, 4.4e-10]) [8.459771852360795,
                                                       14.051201868453454,
                                                       2.291368308784527]
@test_approx_eq flux2mag(1) -21.1
@test_approx_eq flux2mag(5.2e-15) 14.609991640913002
@test_approx_eq flux2mag(5.2e-15, 15) 20.709991640913003
@test_approx_eq flux2mag(5.2e-15, ABwave=15) 27.423535345634598


# Test gal_uvw
let
    local u, v, w
    u, v, w = gal_uvw([ten(1,9,42.3)*15], [ten(61,32,49.5)], [627.89], [77.84],
                      [-321.4], [1e3/129], lsr=true)
    @test_approx_eq u [118.2110474553902]
    @test_approx_eq v [-466.4828898385057]
    @test_approx_eq w [88.16573278565097]
    u, v, w = gal_uvw(1, 2, 3, 4, 5, 6)
    @test_approx_eq u  4.0228405867158745
    @test_approx_eq v  3.7912174342038227
    @test_approx_eq w -3.1700191400725464
end

# Test geo2eci
let
    local x, y, z
    x, y, z = geo2eci([0], [0], [0], [2452343])
    @test_approx_eq x [6214.846433007192]
    @test_approx_eq y [-1433.9858454345972]
    @test_approx_eq z [0.0]
    x, y, z = geo2eci((0,0,0), jdcnv(DateTime("2015-06-30T14:03:12.857")))
    @test_approx_eq x -4024.8671780315185
    @test_approx_eq y 4947.835465127513
    @test_approx_eq z 0.0
end

# Test geo2geodetic
let
    local lat, long, alt
    lat, long, alt = geo2geodetic([90], [0], [0], "Jupiter")
    @test_approx_eq lat [90]
    @test_approx_eq long [0]
    @test_approx_eq alt [4355.443799999994]
    lat, long, alt = geo2geodetic((90, 0, 0))
    @test_approx_eq lat 90
    @test_approx_eq long 0
    @test_approx_eq alt 21.38499999999931
    lat, long, alt = geo2geodetic((43.16, -24.32, 3.87), 8724.32, 8619.19)
    @test_approx_eq lat 43.849399515234516
    @test_approx_eq long -24.32
    @test_approx_eq alt 53.53354478670836
    lat, long, alt = geo2geodetic([43.16], [-24.32], [3.87], 8724.32, 8619.19)
    @test_approx_eq lat [43.849399515234516]
    @test_approx_eq long [-24.32]
    @test_approx_eq alt [53.53354478670836]
end

# Test geo2mag
let
    local lat, long
    lat, long = geo2mag(ten(35,0,42), ten(135,46,6), 2016)
    @test_approx_eq lat 36.86579228937769
    @test_approx_eq long -60.184060536651614
    lat, long = geo2mag([15], [24], 2016)
    @test_approx_eq lat [11.452100529696096]
    @test_approx_eq long [-169.86030510727102]
end

# Test geodetic2geo
let
    local lat, long, alt
    lat, long, alt = geodetic2geo([90], [0], [0], "Jupiter")
    @test_approx_eq lat [90]
    @test long == [0]
    @test_approx_eq alt [-4355.443799999994]
    lat, long, alt = geodetic2geo((90, 0, 0))
    @test_approx_eq lat 90
    @test long == 0
    @test_approx_eq alt -21.38499999999931
    lat, long, alt = geodetic2geo((43.16, -24.32, 3.87), 8724.32, 8619.19)
    @test_approx_eq lat 42.46772711708433
    @test long == -24.32
    @test_approx_eq alt -44.52902080669082
    lat, long, alt = geodetic2geo([43.16], [-24.32], [3.87], 8724.32, 8619.19)
    @test_approx_eq lat [42.46772711708433]
    @test long == [-24.32]
    @test_approx_eq alt [-44.52902080669082]
    # Test geodetic2geo is the inverse of geo2geodetic, within a certain
    # tolerance.
    lat, long, alt = geodetic2geo(geo2geodetic(67.2,13.4,1.2))
    @test_approx_eq_eps lat 67.2 1e-8
    @test long == 13.4
    @test_approx_eq_eps alt 1.2 1e-9
end

# Test get_date with mixed keywords.
@test get_date(DateTime(2001,09,25,14,56,14), old=true,timetag=true) ==
    "25/09/2001T14:56:14"
@test get_date(DateTime(2001,09,25,14,56,14)) == "2001-09-25"

# Test gcirc.
@test_approx_eq gcirc(0, [0,1,2], [1,2,3], [2,3,4], [3,4,5]) [1.222450611061632,
                                                              2.500353926443337,
                                                              1.5892569925227757]
@test_approx_eq gcirc(0,  120, -43,   175, +22)  1.590442261600714
@test_approx_eq gcirc(1, (120, -43),  175, +22)  415908.56615322345
@test_approx_eq gcirc(2,  120, -43,  (175, +22)) 296389.3666794745
@test_approx_eq gcirc(0, (120, -43), (175, +22)) 1.590442261600714
@test_approx_eq gcirc(1, [120], [-43],  175, +22)  [415908.56615322345]
@test_approx_eq gcirc(2,  120, -43,  [175], [+22]) [296389.3666794745]
@test_throws ErrorException gcirc(3, 0, 0, 0, 0)

# Test hadec2altaz
let
    local alt1, az1, alt2, az2
    alt1, az1 = hadec2altaz([0], [11.978165], [ten(43,4,42)])
    @test_approx_eq alt1 [58.89983166666667]
    @test_approx_eq az1 [180.0]
    @test_approx_eq hadec2altaz((0, 11.978165), ten(43,4,42), ws=true)[2] 0.0
    alt1, az1 = 50, 20
    alt2, az2 = hadec2altaz(altaz2hadec(alt1, az1, 40), 40)
    @test_approx_eq alt1 alt2
    @test_approx_eq az1  az2
end

# Test jdcnv.
@test_approx_eq jdcnv(DateTime(-4713, 11, 24, 12)) 0.0
@test_approx_eq jdcnv(DateTime(763, 09, 18, 12)) 2000000.0
@test (jd=1234567.89; jdcnv(daycnv(jd)) == jd)

# Test juldate with Gregorian Calendar in force.  This also makes sure precision
# of the result is high enough.  Note that "juldate(dt::DateTime) =
# Dates.datetime2julian(dt)-2.4e6" would not be precise.
@test_approx_eq juldate(DateTime(2016, 1, 1, 8)) (57388.5 + 1.0/3.0)

# Test juldate with Julian Calendar in force, for different centuries.  This
# also makes sure precision of the result is high enough.
@test_approx_eq juldate(DateTime(1582, 10, 1, 20)) (-100843.0 + 1.0/3.0)
@test_approx_eq juldate(DateTime(1000, 1, 1, 20)) (-313692.0 + 1.0/3.0)
@test_approx_eq juldate(DateTime(100, 10, 25, 20)) (-642119.0 + 1.0/3.0)
@test_approx_eq juldate(DateTime(-4713, 1, 1, 12)) -2.4e6
# Test daycnv and juldate together, with Gregorian Calendar in force.  Note that
# they are not expected to be one the inverse of the other during Julian
# Calendar.
@test (dt=DateTime(2016, 1, 1, 20);
       daycnv(juldate(dt) + 2.4e6) == dt)

# Test kepler_solver
@test_approx_eq kepler_solver(8pi/3, 0.7) 2.5085279492864223
@test_approx_eq kepler_solver(pi/4, 0) pi/4
@test_approx_eq kepler_solver(3pi/2, 0.8) -2.2119306096084457
@test_approx_eq kepler_solver(0, 1) 0.0
@test_throws ErrorException kepler_solver(pi, -0.5)
@test_throws ErrorException kepler_solver(pi,  1.5)

# Test mag2flux
let
    local vel, lsf
    vel, lsf = lsf_rotate(3, 90)
    @test length(vel) == length(lsf) == 61
    vel, lsf = lsf_rotate(5, 10)
    @test_approx_eq vel collect(-10.0:5.0:10.0)
    @test_approx_eq lsf [0.0, 0.556914447710896, 0.6933098861837907, 0.556914447710896, 0.0]
end

# Test mag2flux
@test_approx_eq mag2flux(4.83, 21.12) 4.1686938347033296e-11
@test_approx_eq mag2flux([4.83], 21.12) 4.1686938347033296e-11
@test_approx_eq flux2mag(mag2flux(15, ABwave=12.), ABwave=12) 15.0
@test_approx_eq mag2flux(8.3) 1.7378008287493692e-12
@test_approx_eq mag2flux(8.3, 12) 7.58577575029182e-9
@test_approx_eq mag2flux(8.3, ABwave=12) 3.6244115683017193e-7

# Test mag2geo
let
    local lat, long
    lat, long = mag2geo(90, 0, 2016)
    @test_approx_eq lat 86.395
    @test_approx_eq long -166.29000000000002
    lat, long = mag2geo([15], [24], 2016)
    @test_approx_eq lat [11.702066965890157]
    @test_approx_eq long [-142.6357492442842]
    # Test geo2mag is approximately the inverse of mag2geo
    lat, long = geo2mag(mag2geo(12.34, 56.78, 2016)..., 2016)
    @test_approx_eq lat 12.34
    @test_approx_eq long 56.78
end

# Test month_conv
@test month_cnv([" januavv  ", "SEPPES ", " aUgUsT", "la"]) == [1, 9, 8, -1]
@test month_cnv([2, 12, 6], short=true, low=true) == ["feb", "dec", "jun"]
@test month_cnv(5, up=true) == "MAY"
@test (list=[1, 2, 3]; month_cnv(month_cnv(list)) == list)
@test (list=["July", "March", "November"]; month_cnv(month_cnv(list)) == list)

# Test paczynski
@test_approx_eq paczynski(-1e-10)  -1e10
@test_approx_eq paczynski(1e-1)    10.037461005722337
@test_approx_eq paczynski(-1)      -1.3416407864998738
@test_approx_eq paczynski(10)       1.0001922892047386
@test_approx_eq paczynski(-1e10)   -1

# Test planck_freq
@test_approx_eq planck_freq([2000], [5000]) [6.1447146126144004e-30]

# Test planck_wave
@test_approx_eq planck_wave([2000], [5000]) [8.127064833530511e-24]

# Test polrec
let
    local x=zeros(Float64, 3), y=zeros(Float64, 3)
    x, y = polrec([1, 2, 3], [pi, pi/2.0, pi/4.0])
    @test_approx_eq x [-1.0, 0.0, 1.5*sqrt(2.0)]
    @test_approx_eq y [ 0.0, 2.0, 1.5*sqrt(2.0)]
    x, y = polrec((2, 135), degrees=true)
    @test_approx_eq x -sqrt(2)
    @test_approx_eq y  sqrt(2)
end

# Test posang.
@test_approx_eq posang(1, ten(13, 25, 13.5), ten(54, 59, 17),
                       ten(13, 23, 55.5), ten(54, 55, 31)) -108.46011246802047
@test_approx_eq posang(0, [0,1,2], [1,2,3], [2,3,4], [3,4,5]) [1.27896824717634,
                                                               1.6840484573313608,
                                                               0.2609280020139511]
@test_approx_eq posang(0,  120, -43,   175, +22)  -1.5842896165356724
@test_approx_eq posang(1, (120, -43),  175, +22)  82.97831348792039
@test_approx_eq posang(2,  120, -43,  (175, +22)) 50.02816530382374
@test_approx_eq posang(0, (120, -43), (175, +22)) -1.5842896165356724
@test_approx_eq posang(1, [120], [-43],  175, +22)  [82.97831348792039]
@test_approx_eq posang(2,  120, -43,  [175], [+22]) [50.02816530382374]
@test_throws ErrorException posang(3, 0, 0, 0, 0)

# Test precess
let
    local ra1, dec1, ra2, dec2
    ra1, dec1 = precess((ten(2,31,46.3)*15, ten(89,15,50.6)), 2000, 1985)
    @test_approx_eq ra1  34.09470328718033
    @test_approx_eq dec1 89.19647174928589
    ra2, dec2 = precess([ten(21, 59, 33.053)*15], [ten(-56, 59, 33.053)], 1950, 1975, FK4=true)
    @test_approx_eq ra2  330.3144305418865
    @test_approx_eq dec2 -56.87186126487889
end

# Test precess_xyz
let
    local x1 ,y1, z1, x2, y2, z2
    x1, y1, z1 = precess_xyz((1.2, 2.3, 1.7), 2000, 2050)
    @test_approx_eq x1 1.165933061423247
    @test_approx_eq y1 2.313228746401996
    @test_approx_eq z1 1.7057470102860104
    x2, y2, z2 = precess_xyz([0.7, -2.4], [3.3, 6.6], [0, 4], 2000, 2016)
    @test_approx_eq x2 [0.688187142071843,   -2.429815562246262]
    @test_approx_eq y2 [3.3024835038223532,   6.591359330834213]
    @test_approx_eq z2 [0.001079105285993004, 3.9962455511755794]
end

# Test premat
@test_approx_eq premat(1967, 1982, FK4=true) [0.9999933170034135    -0.0033529069683496567 -0.0014573823699636742
                                              0.00335290696825777    0.9999943789886484    -2.443304965138481e-6
                                              0.0014573823701750721 -2.4431788671274868e-6  0.9999989380147651   ]

@test_approx_eq premat(1995, 2003) [ 0.9999980977132219    -0.0017889257711428855  -0.0007773766929507687
                                     0.0017889257711354528  0.9999983998707707     -6.953448226403318e-7
                                     0.0007773766929678732 -6.953257000046125e-7    0.9999996978424512  ]

# Test radec
@test radec(15.90, -0.85) == (1.0, 3.0, 36.0, -0.0, 51.0, 0.0)
@test radec(-0.85,15.9) == (23.0,56.0,36.0,15.0,54.0,0.0)
@test radec(-20,4,hours=true) == (4.0,0.0,0.0,4.0,0.0,0.0)
@test radec([15.90, -0.85], [-0.85,15.9]) ==
    ([1.0, 23.0], [3.0, 56.0], [36.0, 36.0],
     [-0.0, 15.0], [51.0, 54.0], [0.0, 0.0])

# Test recpol
let
    local r = a = zeros(Float64, 3)
    r, a = recpol([0, sqrt(2.0), 2.0*sqrt(3.0)],
                  [0, sqrt(2.0), 2.0])
    @test_approx_eq r [0.0,  2.0,  4.0]
    @test_approx_eq a [0.0, pi/4.0, pi/6.0]
    r, a = recpol(1, 1)
    @test_approx_eq r sqrt(2.0)
    @test_approx_eq a pi/4.0
    # Test polrec is the inverse of recpol
    local xi = 6.3, yi = -2.7, x = y = 0.0
    x, y = polrec(recpol((xi, yi), degrees=true), degrees=true)
    @test_approx_eq x xi
    @test_approx_eq y yi
end

# Test rhotheta
let
    local ρ, θ
    ρ, θ = rhotheta(41.623, 1934.008, 0.2763, 0.907, 59.025, 23.717, 219.907, 1980)
    @test_approx_eq ρ 0.41101776646245836
    @test_approx_eq θ 318.4242564860495
end

# Test "sixty".  Test also it's the reverse of ten.
@test_approx_eq sixty(-51.36) [-51.0, 21.0, 36.0]
@test_approx_eq ten(sixty(-0.10934835545824395)) -0.10934835545824395
@test_approx_eq sixty(1) [1.0, 0.0, 0.0]

# Test sphdist.
@test_approx_eq sphdist([0,1,2], [1,2,3], [2,3,4], [3,4,5]) [1.222450611061632,
                                                             2.500353926443337,
                                                             1.5892569925227762]
@test_approx_eq sphdist(120, -43, 175, +22) 1.5904422616007134
@test_approx_eq sphdist([120], [-43], 175, +22) 1.5904422616007134
@test_approx_eq sphdist(120, -43, [175], [+22]) 1.5904422616007134

# Test "ten" and "tenv".  Always make sure string and numerical inputs are
# consistent (IDL implementation of "ten" is not).
@test ten(0, -23, 34) == ten(" : 0 -23 :: 34") == -0.37388888888888894
@test ten(-0.0, 60) == ten("-0.0 60") == -1.0
@test ten([-5, -60, -3600]) == ten("  -5: :-60: -3600") == -3.0
@test ten("") == 0.0
@test tenv([0, -0.0, -5], [-23, 60, -60], [34, 0, -3600]) ==
    tenv(["0   -23 :: 34", ":-0.0:60", " -5:-60: -3600"]) ==
    [-0.37388888888888894, -1.0, -3.0]
@test tenv([12.0, -0.0], [24, 30]) == tenv([" 12::24", " -0:30: "]) == [12.4, -0.5]

# Test vactoair and that airtovac is its inverse (it isn't true only around
# 2000, just avoid those values)
@test_approx_eq vactoair([2000]) [1999.3526230448367]
@test_approx_eq airtovac(vactoair(collect(1000:300:4000))) collect(1000:300:4000)

# Test xyz
let
    local x, y, z, vx, vy, vz
    x, y, z, vx, vy, vz = xyz([51200.5 + 64./86400.], 2000)
    @test_approx_eq x  [0.5145687092402946]
    @test_approx_eq y  [-0.7696326261820777]
    @test_approx_eq z  [-0.33376880143026394]
    @test_approx_eq vx [0.014947267514081075]
    @test_approx_eq vy [0.008314838205475709]
    @test_approx_eq vz [0.003606857607574784]
end

# Test ydn2md.
@test ydn2md(2016, [60, 234]) == [Date(2016, 02, 29), Date(2016, 08, 21)]
@test ymd2dn(ydn2md(2016, 60)) == 60

# Test ymd2dn
@test ymd2dn([Date(2015,3,5), Date(2016,3,5)]) == [64, 65]
@test ydn2md(2016, ymd2dn(Date(2016, 09, 16))) == Date(2016, 09, 16)
