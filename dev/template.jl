# Options
user    = "JuliaFewBody"
authors = ["Shuhei Ohno", "Martin Mikkelsen"]
repo    = "FewBodyHamiltonians.jl"

# Package Template
using PkgTemplates
PkgTemplates.generate(
  repo,
  Template(;
    dir     = pwd(),
    user    = user,
    authors = authors,
    julia   = v"1.11",
    plugins = [
      # https://juliaci.github.io/PkgTemplates.jl/stable/user/#Default-Plugins
      ProjectFile(; version = v"0.0.1"),
      SrcDir(),
      Tests(; project = true),
      Readme(),
      License(),
      Git(; ignore = ["*/Manifest.toml"]),
      GitHubActions(; extra_versions = ["1.11"]),
      CompatHelper(),
      TagBot(),
      # Secret(),
      Dependabot(),
      # https://juliaci.github.io/PkgTemplates.jl/stable/user/#Documentation
      Documenter{GitHubActions}(),
      # https://juliaci.github.io/PkgTemplates.jl/stable/user/#Miscellaneous
      Citation(; readme = true),
      Formatter(),
    ],
  ),
)

# Deploy Keys
using DocumenterTools
DocumenterTools.genkeys(;
  user = user,
  repo = repo,
)
