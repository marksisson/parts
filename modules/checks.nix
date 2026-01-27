{ config, ... }:
let
  components = config.components;

  module = { inputs, ... }: {
    imports = [ inputs.git-hooks.flakeModule ];
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
      components.nixology.shells
      components.nixology.systems
    ];
  };
in
{
  imports = [ partitionedModule ];
  components.nixology.checks = component;
}
