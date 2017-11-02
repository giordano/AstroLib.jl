using Documenter, AstroLib

makedocs(
    modules = [AstroLib],
    format = :html,
    sitename = "AstroLib",
    pages    = Any[
        "Introduction"   => "index.md",
        "Reference"      => "ref.md",
    ]
)

deploydocs(
    repo = "github.com/JuliaAstro/AstroLib.jl.git",
    target = "build",
    deps = nothing,
    make = nothing,
    julia  = "0.6",
)
