{ config, ... }:
let
  components = config.components;

  module = { inputs, ... }: {
    imports = [ inputs.treefmt.flakeModule ];
    perSystem = { config, pkgs, ... }:
      {
        treefmt =
          {
            projectRootFile = "flake.nix";
            package = pkgs.treefmt;
            programs = {
              nixpkgs-fmt.enable = true;
              shfmt.enable = true;
            };
          };

        shells.default.packages = with config.treefmt; builtins.attrValues build.programs;
      };
  };

  partitionedModule = {
    partitions.development = { inherit module; };
  };

  component = {
    inherit module;
    dependencies = [
      components.nixology.shells
      components.nixology.systems
    ];
  };
in
{
  imports = [ partitionedModule ];
  components.nixology.formatter = component;
}
