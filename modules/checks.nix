{ config, ... }:
let
  # Get extra inputs from the development partition
  inputs = config.partitions.development.extraInputs;

  localModule = {
    imports = [ inputs.git-hooks.flakeModule ];

    perSystem = { config, lib, options, pkgs, system, ... }: {
      shells.default.packages = with config.pre-commit; settings.enabledPackages;

      shells.default.shellHook = "${with config.pre-commit; shellHook}";
    };
  };

  flakeModule = {
    key = "FBE84DEC-411A-4809-A9FB-39D59DB330E4";

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
  flake.modules.flake.checks = flakeModule;
}
