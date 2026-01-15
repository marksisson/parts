let
  flakeModule =
    let
      _file = __curPos.file;
    in
    {
      inherit _file;
      key = _file;

      debug = true;
    };
in
{
  # import locally (dogfooding)
  imports = [ flakeModule ];
  # export via flakeModules
  flake.modules.flake.debug = flakeModule;
}
