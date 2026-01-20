{ config, self, ... }:
let
  componentName = "devShells";
  componentFile = __curPos.file;

  key = with config.meta; config.flake.lib.mkComponentKey { inherit flakeName flakeVersion componentName componentFile; };

  module = { lib, ... }:
    {
      config = {
        perSystem = { config, pkgs, system, ... }: {
          devShells = lib.mapAttrs
            (name: shell: pkgs.mkShell.override shell.mkShellOverrides {
              inherit (shell) inputsFrom name packages shellHook stdenv;
            })
            config.shells;
        };
      };
    };

  component = {
    inherit key;
    imports = [
      module
      self.flakeModules.shells
    ];
  };
in
{
  imports = [ module ];
  flake.modules.flake.${componentName} = component;
}
