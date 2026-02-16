{
  description = "A collection of flake components for various purposes.";

  inputs.std.url = "git+ssh://git@github.com/marksisson/std";

  outputs = inputs:
    let flakeref = "github:nixology/parts"; in with inputs.std.lib;
    mkFlake { inherit flakeref inputs; } { imports = modulesIn ./modules; };
}
