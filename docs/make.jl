using Documenter, AstroLib

makedocs(
    modules = [AstroLib],
    sitename = "AstroLib",
    pages    = [
        "Introduction"   => "index.md",
        "Reference"      => "ref.md",
    ]
)

deploydocs(
    repo = "github.com/JuliaAstro/AstroLib.jl.git",
)
