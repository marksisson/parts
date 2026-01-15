{ inputs, ... }:
let
  flakeModule = { ... }:
    let
      _file = __curPos.file;
    in
    {
      inherit _file;
      key = _file;

      imports = [ inputs.flake-parts.flakeModules.modules ];
    };
in
{
  # import locally (dogfooding)
  imports = [ flakeModule ] ++
    # need to import flakeModules.modules here since we use it below (i.e. flake.modules.flake.modules)
    [ inputs.flake-parts.flakeModules.modules ];
  # export via flakeModules
  flake.modules.flake.modules = flakeModule;
}
