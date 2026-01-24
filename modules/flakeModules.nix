{ config, inputs, ... }:
let
  module = { config, ... }:
    {
      flake.flakeModules =
        config.nixology.components //
        { default = { imports = builtins.attrValues config.nixology.components; }; };
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
