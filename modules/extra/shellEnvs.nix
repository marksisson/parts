{ inputs, ... }:
let
  module =
    { flake-parts-lib, lib, ... }:
    {
      options = {
        perSystem = flake-parts-lib.mkPerSystemOption (
          { pkgs, ... }:
          with lib;
          with types;
          let
            shellEnvs = mkOption {
              type = lazyAttrsOf shellEnv;
              default = { };
              description = "Development shell environments.";
            };

            shellEnv = submodule {
              options = {
                inherit
                  inputsFrom
                  mkShellOverrides
                  packages
                  shellHook
                  stdenv
                  ;
              };
            };

            inputsFrom = mkOption {
              type = listOf package;
              default = [ ];
              description = "List of packages whose inputs and shell hooks will be included in the development shell environment.";
            };

            mkShellOverrides = mkOption {
              type = lazyAttrsOf anything;
              default = { };
              description = "Overrides to apply to the development shell environment.";
            };

            packages = mkOption {
              type = listOf package;
              default = [ ];
              description = "List of packages to include in development shell environment.";
            };

            shellHook = mkOption {
              type = lines;
              default = "";
              description = "Shell hook script to run when entering the development shell environment.";
            };

            stdenv = mkOption {
              type = package;
              default = pkgs.stdenvNoCC;
              description = "The stdenv to use for the development shell environment.";
            };
          in
          {
            options = { inherit shellEnvs; };
          }
        );
      };

      config = {
        perSystem =
          {
            config,
            lib,
            pkgs,
            ...
          }:
          lib.mkIf (config.shellEnvs != { }) {
            devShells = lib.mapAttrs (
              name: shellEnv:
              pkgs.mkShell.override shellEnv.mkShellOverrides {
                inherit name;
                inherit (shellEnv)
                  inputsFrom
                  packages
                  shellHook
                  stdenv
                  ;
              }
            ) config.shellEnvs;
          };
      };
    };

  partitionedModule = {
    partitions.development = { inherit module; };
  };

  component = {
    inherit module;
    dependencies = with inputs.self.components; [
      nixology.systems.default
      nixology.flake.devShells
    ];
    meta = {
      shortDescription = "development shell environments";
    };
  };
in
{
  imports = [ partitionedModule ];
  flake.components = {
    nixology.extra.shellEnvs = component;
  };
}
