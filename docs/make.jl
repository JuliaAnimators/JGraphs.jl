using JGraphs
using Documenter

DocMeta.setdocmeta!(JGraphs, :DocTestSetup, :(using JGraphs); recursive = true)

makedocs(;
    modules = [JGraphs],
    authors = "Giovanni Puccetti",
    repo = "https://github.com/gpucce/JGraphs.jl/blob/{commit}{path}#{line}",
    sitename = "JGraphs.jl",
    format = Documenter.HTML(;
        prettyurls = get(ENV, "CI", "false") == "true",
        canonical = "https://gpucce.github.io/JGraphs.jl",
        assets = String[],
    ),
    pages = ["Home" => "index.md"],
)

deploydocs(; repo = "github.com/gpucce/JGraphs.jl", devbranch="main")
