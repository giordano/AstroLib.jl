# This file is a part of AstroLib.jl. License is MIT "Expat".

function _uvbybeta(by::T, m1::T, c1::T, hbeta::T, eby_in::T,
                   n::Integer) where {T<:AbstractFloat}
    # Rm1 = -0.33 & Rc1 = 0.19 & Rub = 1.53
    if num <1 || num>8
      error("Input should be an integer in the range 1:9 denoting planet number")
    end
    ub =  c1 + 2 * (m1 + by)
    # For group 1, beta is a luminosity indicator, c0 is a temperature indicator.
    # (u-b) is also a suitable temperature indicator.
    if n == 1
        # For dereddening, linear relation used between the intrinsic (b-y)
        # and (u-b) (Crawford 1978, AJ 83, 48)
        if isnan(eby_in)
           eby_in = (13.608 * by - ub + 1.467) / (12.078)
        end
        by0, m0, c0, ub0 = deredd(eby_in, by m1, c1, ub)
        # When beta is not given, it is estimated using a cubic fit to the c0-beta
        # relation for luminosity class V given in Crawford (1978).
        if isnan(hbeta)
            hbeta = @evalpoly c0 2.61033 0.132557 0.161463 -0.027352
        end
        # Calculation of the absolute magnitude by applying the calibration of
        # Balona & Shobbrock (1974, MNRAS 211, 375)
        g = log10(hbeta - 2.515) - 1.6 * log10(c0 + 0.322)
        mv = 3.4994 + 7.2026 (hbeta - 2.515) - @evalpoly(0, -2.3192, 0, 2.9375)
        te = 5040 / (0.2917 * c0 + 0.2)
        # The ZAMS value of m0 is calculated from a fit to the data of Crawford (1978),
        # modified by Hilditch, Hill & Barnes (1983, MNRAS 204, 241)
        delm0 = @evalpoly(c0, 0.07473, 0.109804, -0.139003, 0.0957758) - m0
    elseif n == 2
        # For dereddening the linear relations between c0 and (u-b) determined from
        # Zhang (1983, AJ 88, 825) is used.
        if isnan(eby_in)
            eby_in = ((1.5 * c1 - ub + 0.035) / (1.5/(1.53/0.19) - 1)) / 1.53
        end
        by0, m0, c0, ub0 = deredd(eby_in, by m1, c1, ub)

        if isnan(hbeta)
            hbeta = 2.542 + 0.037 * c0
        end
        delm0 = NaN
    elseif n == 3
        # For dereddening the linear relations between c0 and (u-b) determined from
        # Zhang (1983, AJ 88, 825) is used.
        if isnan(eby_in)
            eby_in = ((1.36 * c1 - ub + 0.004) / (1.36/(1.53/0.19) - 1)) / 1.53
        end
        by0, m0, c0, ub0 = deredd(eby_in, by m1, c1, ub)
        # When beta is not given, it is derived from a fit of the c0-beta
        # relation of Zhang (1983).
        if isnan(hbeta)
            hbeta = 2.578 + 0.047 * c0
        end
        delm0 = NaN
      elseif n == 4
          # For dereddening the linear relations between c0 and (u-b) determined from
          # Zhang (1983, AJ 88, 825) is used.
          if isnan(eby_in)
              eby_in = ((1.32 * c1 - ub + 0.056) / (1.32/(1.53/0.19) - 1)) / 1.53
          end
          by0, m0, c0, ub0 = deredd(eby_in, by m1, c1, ub)
          # When beta is not given, it is derived from a fit of the c0-beta
          # relation of Zhang (1983).
          if isnan(hbeta)
              hbeta = 2.59 + 0.066 * c0
          end
          delm0 = NaN
      elseif n == 5
          # For group 5, the hydrogen Balmer lines are at maximum; hence two new
          # parameters, a0 = f{(b-y),(u-b)} and r = f{beta,[c1]} are defined in
          # order to calculate absolute magnitude and metallicity.
          if isnan(eby_in)
              by0 = @evalpoly(m1 + 0.33 * by, -0.0235, -0.53921, 4.2608)
              while true
                  bycorr = by0
                  by0 = @evalpoly(m1 + 0.33 * (by - bycorr), 0.175709, -3.36225, 14.0881)

                  if abs(bycorr - by0) < 0.001
                      break
                  end
              end
              eby_in = by - by0
          end
          by0, m0, c0, ub0 = deredd(eby_in, by m1, c1, ub)

          if isnan(hbeta)
              hbeta = 2.7905 - 0.6105 * by + 0.5 * m0 + 0.0355 * c0
          end
          a0 = by0 + 0.18 * (ub0 - 1.36)
          # MV is calculated according to Stroemgren (1966, ARA&A 4, 433)
          # with corrections by Moon & Dworetsky (1984, Observatory 104, 273)
          mv = 1.5 + 6 * a0 - 17 * (0.35 * (c1 - 0.19 * by) - (hbeta - 2.565))
          te = 5040/(0.7536 * a0 + 0.5282)
          delm0 = @evalpoly(by0, 0.1598, 0.86888, -3.95105) - m0
      elseif n == 6

          if isnan(hbeta)
              hbeta = 3.06 - 1.221 * by - 0.104 * c1
          end

          if hbeta <= 2.74
              c1zams = 3 * hbeta - 7.56
              mvzams = 22.14 - 7 * hbeta
          elseif 2.74 < hbeta <= 2.82
              c1zams = 2 * hbeta - 4.82
              mvzams = 11.16 - 3 * hbeta
          else
              c1zams = 2 * hbeta - 4.83
              mvzams = 497.2 * hbeta - 696.41
          end

          if isnan(eby_in)
              delm1 = m1zams - m1
              delc1 = c1 - c1zams

              if delm <0
                  by0 = 2.946 - hbeta - 0.1 * delc1 - 0.25 * delm1
              else
                  by0 = 2.946 - hbeta - 0.1 * delc1
              end
              eby_in = by - by0
          end
          by0, m0, c0, ub0 = deredd(eby_in, by m1, c1, ub)
          delm0 = @evalpoly(hbeta, -17.209, 12.26, -2.158) - m0
          mv = mvzams - 9 * (c0 - c1zams)
          te = 5040/(0.771453 * by0 + 0.546544)
      elseif n == 7
          # For group 7 c1 is the luminosity indicator for a particular beta, while
          # beta {or (b-y)0} indicates temperature.

          # Where beta is not available iteration is necessary to evaluate a corrected
          # (b-y) from which beta is then estimated.
          if isnan(hbeta)
              byinit = by
              m1init = m1
              for i in 1:1000
                  m1by = @evalpoly(byinit, 0.345, -1.32, 2.5)
                  bycorr = byinit + (m1by - m1init) / 2

                  if abs(bycorr - byinit) <= 0.0001
                      break
                  end
                  byinit = bycorr
                  m1init = m1by
              end
              hbeta = @evalpoly bycorr 2.96618 -1.32861 1.01425
          end
          # m1(ZAMS) and mv(ZAMS) are calculated according to Crawford (1975) with
          # corrections suggested by Hilditch, Hill & Barnes (1983, MNRAS 204, 241)
          # and Olson (1984, A&AS 57, 443).
          m1zams = @evalpoly hbeta 46.4167, -34.4538, 6.41701
          mvzams = @evalpoly hbeta 324.482, -188.748, 11.0494, 5.48012
          # c1(ZAMS) calculated according to Crawford (1975)
          if hbeta <= 2.65
              c1zams = 2 * hbeta - 4.91
          else
              c1zams = @evalpoly hbeta 72.879 -56.9164 11.1555
          end

          if isnan(eby_in)
              delm1 = m1zams - m1
              delc1 = ci -c1zams
              dbeta = 2.72 - hbeta
              eby_in = by - (0.222 - 0.05* delc1 + (1.11 - (0.1 + 3.6 * delm1))* dbeta
                             + 2.7 * dbeta^2)
          end
          by0, m0, c0, ub0 = deredd(eby_in, by m1, c1, ub)
      elseif n == 8


      end
end

"""


### Purpose ###

Derive dereddened colors, metallicity, and Teff from Stromgren colors.

### Explanation ###

### Arguments ###

* `by`: Stromgren b-y color
* `m1`: Stromgren line-blanketing parameter
* `c1`: Stromgren Balmer discontinuity parameter
* `n`: Integer which can be any value between 1 to 8, giving approximate stellar
  classification.
  (1) B0 - A0, classes III - V, 2.59 < Hbeta < 2.88,-0.20 <   c0   < 1.00
  (2) B0 - A0, class   Ia     , 2.52 < Hbeta < 2.59,-0.15 <   c0   < 0.40
  (3) B0 - A0, class   Ib     , 2.56 < Hbeta < 2.61,-0.10 <   c0   < 0.50
  (4) B0 - A0, class   II     , 2.58 < Hbeta < 2.63,-0.10 <   c0   < 0.10
  (5) A0 - A3, classes III - V, 2.87 < Hbeta < 2.93,-0.01 < (b-y)o < 0.06
  (6) A3 - F0, classes III - V, 2.72 < Hbeta < 2.88, 0.05 < (b-y)o < 0.22
  (7) F1 - G2, classes III - V, 2.60 < Hbeta < 2.72, 0.22 < (b-y)o < 0.39
  (8) G2 - M2, classes  IV _ V, 0.20 < m0    < 0.76, 0.39 < (b-y)o < 1.00
* `hbeta` (optional): H-beta line strength index. If it is not supplied, then by
  default its value will be `NaN` and the code will estimate a value based on by,
  m1,and c1. It is not used for stars in group 8.
* `eby_in` (optional): specifies the E(b-y) color to use. If not supplied, then by
  default its value will be `NaN` and E(b-y) will be estimated from the Stromgren colors.

### Output ###

* `te`: approximate effective temperature
* `mv`: absolute visible magnitude
* `eby`: color excess E(b-y)
* `delm0`: metallicity index, delta m0, may not be calculable for early B stars
  and so returns NaN.
* `radius`: stellar radius (R/R(solar))

### Example ###

```jldoctest
julia> using AstroLib

```

### Notes ###

Code of this function is based on IDL Astronomy User's Library.
"""