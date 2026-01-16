let
  localModule = {
    debug = true;
  };

  flakeModule =
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
  flake.modules.flake.debug = flakeModule;
}
