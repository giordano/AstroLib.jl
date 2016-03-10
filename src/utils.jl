using Dates

"""
    daycnv(julian_days) -> DateTime

Takes the number of Julian calendar days since epoch `-4713-11-24T12:00:00` and returns the
corresponding `DateTime`.
"""
const daycnv=Dates.julian2datetime

"""
    get_date(date::DateTime) -> ASCIIString

Returns the UTC date in `"CCYY-MM-DD"` format for FITS headers.

The `date` should be a `DateTime` in UTC standard, if omitted it defaults to the
current UTC time.

When no optional keywords (`timetag` and `old`) are supplied, the format of the
output string is `"CCYY-MM-DD"` (year-month-day part of the date), where <CCYY>
represents a 4-digit calendar year, <MM> the 2-digit ordinal number of a
calendar month within the calendar year, and <DD> the 2-digit ordinal number of
a day within the calendar month.

    get_date(date::DateTime; old=true) -> ASCIIString

If the boolean keyword `old` is true (default: false), the year-month-day part
of date has `"DD/MM/YY"` format.  This is the formerly (pre-1997) recommended
for FITS.  Note that this format is now deprecated because it uses only a
2-digit representation of the year.

    get_date(date::DateTime; timetag=true) -> ASCIIString

If the boolean keyword `timetag` is true (default: false), `"Thh:mm:ss"` is
appended to the year-month-day part of the date, where <hh> represents the hour
in the day, <mm> the minutes, <ss> the seconds, and the literal 'T' the ISO 8601
time designator.

Note that `old` and `timetag` keywords can be used together, so that the output
string will have `"DD/MM/YYThh:mm:ss"` format.
"""
function get_date(dt::DateTime=Dates.unix2datetime(Libc.time());
                  old::Bool=false, timetag::Bool=false)
    # Based on `Base.string' definition in base/dates/io.jl.
    y, m, d = Dates.yearmonthday(dt)
    h, mi, s = Dates.hour(dt), Dates.minute(dt), Dates.second(dt)

    yy = lpad(y,4,"0") # here y is supposed to be positive.
    mm = lpad(m,2,"0")
    dd = lpad(d,2,"0")
    hh = lpad(h,2,"0")
    mii = lpad(mi,2,"0")
    ss = lpad(s,2,"0")

    # Set year-month-day string (ymds).
    ymds = old ? "$(dd)/$(mm)/$(yy)" : "$(yy)-$(mm)-$(dd)"

    if timetag
        return "$(ymds):T$(hh):$(mii):$(ss)"
    else
        return ymds
    end
end
