{ config, self, ... }:
let
  module = {
    perSystem = { config, pkgs, ... }: {
      treefmt = {
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
    imports = [
      module
      (with config.partitions.development; extraInputs.treefmt.flakeModule)
      self.flakeModules.shells
      self.flakeModules.systems
    ];
  };
in
{
  imports = [ partitionedModule ];
  flake.modules.flake.formatter = component;
}
