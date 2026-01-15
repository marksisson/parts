let
  flakeModule = { lib, moduleLocation, ... }:
    let
      _file = __curPos.file;
    in
    {
      inherit _file;
      key = _file;

      options = {
        flake.darwinModules = lib.mkOption {
          type = lib.types.lazyAttrsOf lib.types.deferredModule;
          default = { };
          apply = lib.mapAttrs (k: v: {
            _class = "darwin";
            _file = "${toString moduleLocation}#darwinModules.${k}";
            imports = [ v ];
          });
          description = ''
            Darwin modules.

            You may use this for reusable pieces of configuration, service modules, etc.
          '';
        };
      };
    };
in
{
  # import locally (dogfooding)
  imports = [ flakeModule ];
  # export via flakeModules
  flake.modules.flake.darwinModules = flakeModule;
}
