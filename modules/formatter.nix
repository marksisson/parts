{ config, ... }:
let
  # Get extra inputs from the development partition
  inputs = config.partitions.development.extraInputs;

  localModule = { options, ... }: {
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

  flakeModule = args:
    let
      _file = __curPos.file;
    in
    {
      inherit _file;
      key = _file;

      imports = [ config.flake.modules.flake.shells ];
    } // localModule args;

  partitionedModule = {
    partitions.development.module = localModule;
  };
in
{
  # import locally (dogfooding)
  imports = [ partitionedModule ];
  # export via flakeModules
  flake.modules.flake.formatter = flakeModule;
}
