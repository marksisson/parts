{ config, ... }:
let
  module = { lib, ... }: {
    options = with lib; with types;
      let
        module = mkOption {
          type = deferredModule;
          description = "The main module of the flake.";
        };

        name = mkOption {
          type = str;
          description = "The name of the flake.";
        };

        version = mkOption {
          type = str;
          default = "0.1.0";
          description = "The version of the flake.";
        };

        flake = mkOption {
          type = submodule {
            options = { inherit module name version; };
          };
          description = "Metadata about the flake.";
        };

        meta = mkOption {
          type = submodule {
            options = { inherit flake; };
          };
          description = "Metadata module for flakes.";
        };
      in
      {
        inherit meta;
      };
  };

  component = {
    inherit module;
  };
in
{
  imports = [ module ];
  components.meta = component;
}
