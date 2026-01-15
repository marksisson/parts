{ inputs, ... }:
let
  flakeModule =
    let
      _file = __curPos.file;
    in
    {
      inherit _file;
      key = _file;

      imports = [ inputs.flake-parts.flakeModules.partitions ];
    };
in
{
  # import locally (dogfooding)
  imports = [ flakeModule ];
  # export via flakeModules
  flake.modules.flake.partitions = flakeModule;
}
