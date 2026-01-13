local@{ config, ... }:
let
  # Get extra inputs from the development partition
  inputs = config.partitions.development.extraInputs;

  flakeModule = { options, ... }:
    let
      _file = ./checks.nix;
    in
    {
      imports = [ inputs.git-hooks.flakeModule ];

      perSystem = { config, lib, system, ... }: {
        inherit _file;

        key = _file + system;

        pre-commit.settings.hooks = {
          treefmt.enable = true;
          treefmt.package = config.treefmt.build.wrapper;
        };
      } // lib.optionalAttrs (options ? shells) {
        shells.default.packages = with config.pre-commit; settings.enabledPackages;

        shells.default.shellHook = ''
          ${with config.pre-commit; shellHook}
        '';
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
  flake.modules.flake.shells = flakeModule;
}
