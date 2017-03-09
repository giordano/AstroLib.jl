# This file is a part of AstroLib.jl. License is MIT "Expat".

"""
    ordinal(num) -> result

### Purpose ###

Convert an integer to a correct English ordinal string:

### Explanation ###
The first four ordinal strings are "1st", "2nd", "3rd", "4th" ....

### Arguements ###

* 'num': number to be made ordinal. If float, will be rounded to 
   largest integer smaller than that float value.

### Output ###

* 'result': ordinal string, such as '1st' '3rd '164th' '87th' etc

### Example ###

``` julia
ordinal(2)
# => "2nd"
ordinal(23.4)
3 => "23rd"
```

### Notes ###

Code of this function is based on IDL Astronomy User's Library.
"""
function ordinal(num::Real)
    num = convert(Int, floor(num))
    a = num % 100
    if a== 11 || a == 12 || a == 13
        suffix = "th"       
    else
        a = num % 10
        if a == 1
            suffix = "st"
        elseif a == 2
            suffix = "nd"
        elseif a == 3
            suffix = "rd"
        else
            suffix = "th"
        end
    end
    return "$num$suffix"      
end

