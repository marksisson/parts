{ config, lib, ... }:
let
  moduleName = "meta";
  moduleFile = __curPos.file;

  key = with config.meta; config.flake.lib.mkModuleKey { inherit flakeName flakeVersion moduleName moduleFile; };

  module = with lib; with types; {
    options = {
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

  flakeModule = {
    inherit key;
    imports = [ module ];
  };
in
{
  imports = [ localModule ];
  flake.modules.flake.${moduleName} = flakeModule;
}
