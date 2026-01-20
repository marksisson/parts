{ config, inputs, ... }:
let
  module = inputs.flake-parts.flakeModules.flakeModules;

  localModule = {
    imports = [ module ];

    # export all flake modules under flake.modules.flake
    flake.flakeModules = config.flake.modules.flake //
      { default = config.flake.modules.flake.systems; };
  };

  component = {
    #key = "7F193AF6-B12D-4FC7-8473-129F2F787F80";
    imports = [ module ];
  };
in
{
  imports = [ localModule ];
  flake.modules.flake.flakeModules = component;
}
