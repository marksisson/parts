{ config, ... }:
let
  # Get extra inputs from the development partition
  inputs = config.partitions.development.extraInputs;

  flakeModule = { options, ... }:
    let
      _file = __curPos.file;
    in
    {
      inherit _file;
      key = _file;

      imports = [
        inputs.treefmt.flakeModule
        config.flake.modules.flake.shells
      ];

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

  partitionedModule = {
    partitions.development.module = flakeModule;
  };
in
{
  # import locally (dogfooding)
  imports = [ partitionedModule ];
  # export via flakeModules
  flake.modules.flake.formatter = flakeModule;
}
