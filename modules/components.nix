{ config, lib, moduleLocation, ... }:
let
  components = config.components;
  meta = config.meta;

  module = { config, ... }: {
    # this module is directly imported from the library function mkFlake
    # so it needs to have a static key to facilitate deduplication
    key = "(import)github:nixology/flake#components.nixology.components";

    options = with lib; with types; let
      name = mkOption {
        type = str;
        default = name;
        description = "The name of the component.";
      };

      version = mkOption {
        type = str;
        description = "The version of the component.";
      };

      module = mkOption {
        type = deferredModule;
        description = "The module defining this component.";
      };

      dependencies = mkOption {
        type = listOf deferredModule;
        default = [ ];
        description = "A list of other components that this component depends on.";
      };

      components = mkOption {
        type = lazyAttrsOf (lazyAttrsOf (submodule ({ name, ... }: {
          options = {
            inherit name version module dependencies;
          };
        })));

        default = { };

        description = "A set of reusable components.";

        apply =
          mapAttrs (namespace: components:
            mapAttrs
              (name: component: {
                key = "${meta.name}#components.${namespace}.${name}";
                imports = [ component.module ] ++ component.dependencies;
                _class = "flake";
                _file = "${moduleLocation}#components.${namespace}.${name}";
              })
              components
          );
      };
    in
    {
      inherit components;
    };
  };

  component = {
    inherit module;
    dependencies = [
      components.nixology.meta
    ];
  };
in
{
  imports = [ module ];
  components.nixology.components = component;
}
