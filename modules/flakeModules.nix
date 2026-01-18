{ config, inputs, ... }:
let
  localModule = {
    # export all flake modules under flake.modules.flake
    flake.flakeModules = config.flake.modules.flake //
      { default = config.flake.modules.flake.systems; };
  };

  flakeModule = let _file = __curPos.file; key = _file; in {
    inherit _file key;

    imports = [
      inputs.flake-parts.flakeModules.flakeModules
    ];
  };
in
{
  imports = [ localModule ];
  flake.modules.flake.flakeModules = flakeModule;
}
