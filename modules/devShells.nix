{ config, ... }:
let
  components = config.components;

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
      components.nixology.flake.shells
      components.nixology.flake.systems
    ];
  };
in
{
  imports = [ partitionedModule ];
  components.nixology.flake.devShells = component;
}
