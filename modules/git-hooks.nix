local@{ config, ... }:
let
  # Get extra inputs from the development partition
  inputs = config.partitions.development.extraInputs;

  flakeModule = { options, ... }: {
    imports = [ inputs.git-hooks.flakeModule ];

    config = {
      perSystem = { config, lib, ... }: {
        pre-commit.settings.hooks = {
          treefmt.enable = true;
          treefmt.package = config.treefmt.build.wrapper;
        };
      } // lib.optionalAttrs (options ? develop) {
        develop.default.packages = with config.pre-commit; settings.enabledPackages;

        develop.default.shellHook = ''
          ${with config.pre-commit; shellHook}
        '';
      };
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
  flake.modules.flake.hooks = flakeModule;
}
