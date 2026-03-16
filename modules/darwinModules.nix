{ config, moduleLocation, ... }:
let
  flake-schemas = config.partitions.schemas.extraInputs.flake-schemas;

  module = { lib, ... }: {
    options = with lib; with types;
      {
        flake.darwinModules = mkOption
          {
            type = lazyAttrsOf deferredModule;
            default = { };
            apply = mapAttrs (name: module: {
              _class = "darwin";
              _file = "${toString moduleLocation}#darwinModules.${name}";
              imports = [ module ];
            });
            description = ''
              Darwin modules.

              You may use this for reusable pieces of configuration, service modules, etc.
            '';
          };
      };

    config = {
      flake.schemas = { inherit (flake-schemas.schemas) darwinModules; };
    };
  };

  component = {
    inherit module;
    meta = {
      shortDescription = "darwin modules";
    };
  };
in
{
  flake.components = { nixology.parts.darwinModules = component; };
}
