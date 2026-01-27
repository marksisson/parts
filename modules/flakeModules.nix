{ config, ... }:
let
  components = config.components;

  module = { config, ... }:
    {
      flake.flakeModules =
        components.nixology //
        { default = { imports = builtins.attrValues components.nixology; }; };
    };

  component = {
    inherit module;
    dependencies = [
      components.nixology.flakeModules
      components.nixology.components
    ];
  };
in
{
  imports = [ module ];
}
