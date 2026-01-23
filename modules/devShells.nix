{ config, ... }:
let
  module = {
    perSystem = { config, lib, pkgs, ... }:
      {
        devShells =
          lib.mapAttrs
            (name: shell: pkgs.mkShell.override shell.mkShellOverrides {
              inherit (shell) inputsFrom name packages shellHook stdenv;
            })
            config.shells;
      };
  };

  partitionedModule = {
    partitions.development = { inherit module; };
  };

  component = {
    inherit module;
    dependencies = [
      config.nixology.components.shells
      config.nixology.components.systems
    ];
  };
in
{
  imports = [ partitionedModule ];
  nixology.components.devShells = component;
}
