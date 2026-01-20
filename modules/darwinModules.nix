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

  component = {
    key = "59C1F9E6-7F5A-43E8-8FE8-75432D6658CF";
    imports = [ module ];
  };
in
{
  flake.modules.flake.darwinModules = component;
}
