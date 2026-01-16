let
  localModule = { lib, moduleLocation, ... }: {
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

  flakeModule = args:
    let
      _file = __curPos.file;
    in
    {
      inherit _file;
      key = _file;
    } // localModule args;
in
{
  # import locally (dogfooding)
  imports = [ localModule ];
  # export via flakeModules
  flake.modules.flake.darwinModules = flakeModule;
}
