{ inputs, ... }:
let
  localModule = {
    imports = [ inputs.flake-parts.flakeModules.modules ];
  };

  flakeModule = { ... }:
    let
      _file = __curPos.file;
    in
    {
      inherit _file;
      key = _file;
    } // localModule;
in
{
  # import locally (dogfooding)
  imports = [ localModule ];
  # export via flakeModules
  flake.modules.flake.modules = flakeModule;
}
