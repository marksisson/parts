{ config, ... }:
let
  # Get extra inputs from the development partition
  inputs = config.partitions.development.extraInputs;

  localModule = {
    imports = [ inputs.git-hooks.flakeModule ];

    perSystem = { config, lib, options, pkgs, system, ... }: {
      shells.default.packages = with config.pre-commit; settings.enabledPackages;

      shells.default.shellHook = ''
        ${with config.pre-commit; shellHook}
      '';
    };
  };

  flakeModule =
    let
      _file = __curPos.file;
    in
    {
      inherit _file;
      key = _file;

      imports = [ config.flake.modules.flake.shells ];
    } // localModule;

  partitionedModule = {
    partitions.development.module = localModule;
  };
in
{
  # import locally (dogfooding)
  imports = [ partitionedModule ];
  # export via flakeModules
  flake.modules.flake.checks = flakeModule;
}
