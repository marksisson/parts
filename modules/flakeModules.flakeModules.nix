{ inputs, ... }:
let
  localModule = {
    imports = [ inputs.flake-parts.flakeModules.flakeModules ];
  };

  flakeModule = let _file = __curPos.file; key = _file; in {
    inherit _file key;

    imports = [
      localModule
    ];
  };
in
{
  imports = [ localModule ];
  flake.modules.flake.flakeModules = flakeModule;
}
