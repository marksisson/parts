{ config, ... }:
let
  componentName = "meta";
  componentFile = __curPos.file;

  key = with config.meta; config.flake.lib.mkComponentKey { inherit flakeName flakeVersion componentName componentFile; };

  module = { lib, ... }: {
    options = with lib; with types; {
      meta = mkOption {
        type = submodule {
          options = {
            flakeName = mkOption {
              type = str;
              description = "A name for the flake.";
            };
            flakeVersion = mkOption {
              type = str;
              description = "The version of the flake.";
            };
          };
        };
      };
      description = "Metadata about the flake.";
    };
  };

  localModule = {
    imports = [ module ];

    meta.flakeName = "github:nixology/flake";
    meta.flakeVersion = "1.0.0";
  };

  component = {
    inherit key;
    imports = [ module ];
  };
in
{
  imports = [ localModule ];
  flake.modules.flake.${componentName} = component;
}
