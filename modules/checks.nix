{ config, self, ... }:
let
  componentName = "checks";
  componentFile = __curPos.file;

  key = with config.meta; config.flake.lib.mkComponentKey { inherit flakeName flakeVersion componentName componentFile; };

  module = {
    perSystem = { config, ... }: {
      shells.default.packages = with config.pre-commit; settings.enabledPackages;
      shells.default.shellHook = "${with config.pre-commit; shellHook}";
    };
  };

  partitionedModule = {
    partitions.development.module = module;
  };

  component = {
    inherit key;
    imports = [
      module
      self.flakeModules.git-hooks
      self.flakeModules.shells
      self.flakeModules.systems
    ];
  };
in
{
  imports = [ partitionedModule ];
  flake.modules.flake.${componentName} = component;
}
