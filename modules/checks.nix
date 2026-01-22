{ config, self, ... }:
let
  module = {
    perSystem = { config, ... }: {
      shells.default.packages = with config.pre-commit; settings.enabledPackages;
      shells.default.shellHook = "${with config.pre-commit; shellHook}";
    };
  };

  partitionedModule = {
    partitions.development = { inherit module; };
  };

  component = {
    imports = [
      module
      (with config.partitions.development; extraInputs.git-hooks.flakeModule)
      self.flakeModules.shells
      self.flakeModules.systems
    ];
  };
in
{
  imports = [ partitionedModule ];
  flake.modules.flake.checks = component;
}
