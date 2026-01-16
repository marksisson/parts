let
  localModule = {
    debug = true;
  };

  flakeModule = let _file = __curPos.file; key = _file; in {
    inherit _file key;
  } // localModule;
in
{
  imports = [ localModule ];
  flake.modules.flake.debug = flakeModule;
}
