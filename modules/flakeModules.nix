{ config, flake-parts-lib, inputs, lib, moduleLocation, ... }:
let
  flakeModulesOption = with lib; with types; mkOption
    {
      type = lazyAttrsOf deferredModule;
      default = { };
      apply = mapAttrs (k: v: {
        _file = "${toString moduleLocation}#flakeModules.${k}";
        imports = [ v ];
        _class = "flake";
      });
      description = ''
        flake-parts modules for use by other flakes.

        If the flake defines only one module, it should be `flakeModules.default`.
      '';
    };

  module2 = with lib; {
    options = {
      flake = mkOption {
        type = types.submoduleWith {
          modules = [
            (mkAliasOptionModule [ "flakeModule" ] [ "flakeModules" "default" ])
            {
              options.flakeModules = flakeModulesOption;
            }
          ];
        };
      };
    };
  };

  module = {
    imports = [ inputs.flake-parts.flakeModules.flakeModules ];
  };

  localModule = {
    imports = [ module ];
    # export all flake modules under flake.modules.flake
    flake.flakeModules = config.flake.modules.flake //
      { default = config.flake.modules.flake.systems; };
  };

  flakeModule = {
    key = "7F193AF6-B12D-4FC7-8473-129F2F787F80";
    imports = [ module ];
  };
in
{
  imports = [ localModule ];
  flake.modules.flake.flakeModules = flakeModule;
}
