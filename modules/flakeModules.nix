{ config, inputs, ... }:
let
  localModule = {
    # export all flake modules under flake.modules.flake
    flake.flakeModules = config.flake.modules.flake //
      { default = config.flake.modules.flake.systems; };
  };

  flakeModule = {
    key = "7F193AF6-B12D-4FC7-8473-129F2F787F80";

    imports = [
      inputs.flake-parts.flakeModules.flakeModules
    ];
  };
in
{
  imports = [ localModule ];
  flake.modules.flake.flakeModules = flakeModule;
}
