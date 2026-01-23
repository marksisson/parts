{ config, ... }:
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
    inherit module;
    dependencies = [
      (with config.partitions.development; extraInputs.git-hooks.flakeModule)
      config.nixology.components.shells
      config.nixology.components.systems
    ];
  };
in
{
  imports = [ partitionedModule ];
  nixology.components.checks = component;
}
