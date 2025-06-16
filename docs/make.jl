using FewBodyHamiltonians
using Documenter

DocMeta.setdocmeta!(FewBodyHamiltonians, :DocTestSetup, :(using FewBodyHamiltonians); recursive=true)

makedocs(;
    modules=[FewBodyHamiltonians],
    authors="Shuhei Ohno, Martin Mikkelsen",
    sitename="FewBodyHamiltonians.jl",
    format=Documenter.HTML(;
        canonical="https://JuliaFewBody.github.io/FewBodyHamiltonians.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/JuliaFewBody/FewBodyHamiltonians.jl",
    devbranch="main",
)
