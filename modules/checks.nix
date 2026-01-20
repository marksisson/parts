{ config, self, ... }:
let
  # Get extra inputs from the development partition
  inputs = config.partitions.development.extraInputs;

  module = {
    imports = [ inputs.git-hooks.flakeModule ];

    perSystem = { config, ... }: {
      shells.default.packages = with config.pre-commit; settings.enabledPackages;
      shells.default.shellHook = "${with config.pre-commit; shellHook}";
    };
  };

  component = {
    key = "FBE84DEC-411A-4809-A9FB-39D59DB330E4";

    imports = [
      module
      self.flakeModules.shells
    ];
  };

  partitionedModule = {
    partitions.development.module = module;
  };
in
{
  imports = [ partitionedModule ];
  flake.modules.flake.checks = component;
}
