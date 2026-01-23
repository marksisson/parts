{ config, ... }:
let
  module = { lib, ... }: {
    # this module is directly imported from the library function mkFlake
    # so it needs to have a static key to facilitate deduplication
    key = "(import)github:nixology/flake#components.meta";
    options = with lib; with types;
      let
        name = mkOption {
          type = str;
          description = "The name of the flake.";
        };

        version = mkOption {
          type = str;
          default = "0.1.0";
          description = "The version of the flake.";
        };

        meta = mkOption {
          type = submodule {
            options = { inherit name version; };
          };
          description = "Metadata module for flakes.";
        };
      in
      {
        nixology = { inherit meta; };
      };
  };

  component = {
    inherit module;
    dependencies = [
      config.nixology.components.nixology
    ];
  };
in
{
  imports = [ module ];
  nixology.components.meta = component;
}
