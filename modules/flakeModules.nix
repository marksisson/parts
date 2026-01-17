{ config, ... }:
let
  localModule = {
    # export all flake modules under flake.modules.flake
    flake.flakeModules = config.flake.modules.flake //
      { default = config.flake.modules.flake.systems; };
  };
in
{
  imports = [ localModule ];
}
