{ config, lib, moduleLocation, ... }:
let
  module =
    {
      options = with lib; with types;
        {
          components = mkOption {
            type = lazyAttrsOf (submodule ({ name, ... }: {
              options = {
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
              };
            }));

            default = { };

            description = "A set of reusable components.";

            apply = mapAttrs (componentName: component: {
              key = with config.meta;
                config.flake.lib.mkComponentKey { inherit flakeName componentName; };
              imports = [ component.module ] ++ component.dependencies;
              _class = "flake";
              _file = "${moduleLocation}#components.${componentName}";
            });
          };
        };
    };

  component = module;
in
{
  imports = [ module ];

  components.components = component;
}
