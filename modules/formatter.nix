{ config, ... }:
let
  # Get extra inputs from the development partition
  inputs = config.partitions.development.extraInputs;

  localModule = {
    imports = [ inputs.treefmt.flakeModule ];

    perSystem = { config, lib, pkgs, system, ... }: {
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

  flakeModule = {
    key = "4D5FE2C3-639C-4061-B0B1-B37BD0FB4A1E";

    imports = [
      config.flake.modules.flake.shells
      localModule
    ];
  };

  partitionedModule = {
    partitions.development.module = localModule;
  };
in
{
  imports = [ partitionedModule ];
  flake.modules.flake.formatter = flakeModule;
}
