{ config, lib, moduleLocation, ... }:
let
  module = { config, ... }:
    {
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
          type = lazyAttrsOf (lazyAttrsOf (lazyAttrsOf (submodule ({ name, ... }: {
            options = {
              inherit name version module dependencies;
            };
          }))));

          default = { };

          description = "A set of reusable components.";

          apply =
            mapAttrs (domain: subdomains:
              mapAttrs
                (subdomain: components:
                  mapAttrs
                    (name: component: {
                      key = "${config.flake.meta.flakeref}#components.${domain}.${subdomain}.${name}";
                      imports = [ component.module ] ++ component.dependencies;
                      _class = "flake";
                      _file = "${moduleLocation}#components.${domain}.${subdomain}.${name}";
                    })
                    components
                )
                subdomains
            );
        };
      in
      {
        flake = { inherit components; };
      };
    };

  component = {
    inherit module;
    dependencies = with config.flake; [
      components.nixology.parts.meta
    ];
  };
in
{
  imports = [ module ];
  flake.components.nixology.parts.components = component;
}
