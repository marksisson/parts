let
  module = { lib, moduleLocation, ... }: {
    options = with lib; with types; {

      flake.darwinModules = mkOption {
        type = lazyAttrsOf deferredModule;
        default = { };
        apply = mapAttrs (k: v: {
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

  component = module;
in
{
  flake.modules.flake.darwinModules = component;
}
