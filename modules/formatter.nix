{ config, ... }:
let
  module = {
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
      (with config.partitions.development; extraInputs.treefmt.flakeModule)
      config.nixology.components.shells
      config.nixology.components.systems
    ];
  };
in
{
  imports = [ partitionedModule ];
  nixology.components.formatter = component;
}
