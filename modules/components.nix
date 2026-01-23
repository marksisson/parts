{ config, lib, moduleLocation, ... }:
let
  module = {
    # this module is directly imported from the library function mkFlake
    # so it needs to have a static key to facilitate deduplication
    key = "(import)github:nixology/flake#components.components";
    options = with lib; with types; let
      name = mkOption {
        type = str;
        default = name;
        description = "The name of the component.";
      };

      module = mkOption {
        type = deferredModule;
        description = "The module defining this component.";
      };

      dependencies = mkOption {
        type = listOf deferredModule;
        default = [ ];
        description = "A list of other modules that this component depends on.";
      };

      components = mkOption {
        type = lazyAttrsOf (submodule ({ name, ... }: {
          options = {
            inherit name module dependencies;
          };
        }));

        default = { };

        description = "A set of reusable components.";

        apply = mapAttrs (componentName: component: {
          key = "${config.nixology.meta.name}#components.${componentName}";
          imports = [ component.module ] ++ component.dependencies;
          _class = "flake";
          _file = "${moduleLocation}#components.${componentName}";
        });
      };
    in
    {
      nixology.components = components;
    };
  };

  component = {
    inherit module;
    dependencies = [
      config.nixology.components.meta
    ];
  };
in
{
  imports = [ module ];
  nixology.components.components = component;
}
