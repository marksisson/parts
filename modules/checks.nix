{ config, inputs, ... }:
let
  module =
    let
      # capture partition inputs from config of outer flake
      # so that is is part of the component
      inputs = config.partitions.development.extraInputs;
    in
    {
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
    dependencies = with inputs.self; [
      components.nixology.parts.shells
      components.nixology.parts.systems
    ];
  };
in
{
  imports = [ partitionedModule ];
  flake.components.nixology.parts.checks = component;
}
