{ config, lib, moduleLocation, ... }:
let
  module = {
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
in
module
