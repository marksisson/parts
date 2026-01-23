{ config, inputs, ... }:
let
  module = { config, ... }: {
    flake.flakeModules = config.nixology.components //
      { default = config.nixology.components.flake; };
  };

  component = {
    inherit module;
    dependencies = [
      inputs.flake-parts.flakeModules.flakeModules
      config.nixology.components.components
    ];
  };
in
{
  imports = [ module ];
  nixology.components.flakeModules = component;
}
