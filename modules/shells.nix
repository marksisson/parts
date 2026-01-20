{ config, inputs, self, ... }:
let
  componentName = "shells";
  componentFile = __curPos.file;

  key = with config.meta; config.flake.lib.mkComponentKey { inherit flakeName flakeVersion componentName componentFile; };

  module = { lib, ... }:
    {
      options = {
        perSystem = inputs.flake-parts.lib.mkPerSystemOption ({ pkgs, ... }: with lib; with types;
          let
            inputsFrom = mkOption {
              type = listOf package;
              default = [ ];
              description = "List of packages whose inputs will be included in the development shell.";
            };

            mkShellOverrides = mkOption {
              type = lazyAttrsOf anything;
              default = { stdenv = pkgs.stdenvNoCC; };
              description = "Overrides to apply to the development shell.";
            };

            packages = mkOption {
              type = listOf package;
              default = [ ];
              description = "List of packages to include in development shell.";
            };

            shellHook = mkOption {
              type = lines;
              default = "";
              description = "Shell hook script to run when entering the development shell.";
            };

            stdenv = mkOption {
              type = package;
              # pkgs.pkgsLLVM.llvmPackages_latest.stdenv
              default = pkgs.stdenv;
              description = "The stdenv to use for the development shell.";
            };

            shells = mkOption {
              type = lazyAttrsOf (submodule ({ name, ... }: {
                options = {
                  name = mkOption {
                    type = str;
                    default = name;
                    description = "Name of the development shell.";
                  };
                  inherit inputsFrom mkShellOverrides packages shellHook stdenv;
                };
              }));
              default = { };
              description = "Development shell configurations.";
            };
          in
          {
            options = { inherit shells; };
          });
      };
    };

  component = {
    #inherit key;
    imports = [ module ];
  };
in
{
  imports = [ module ];
  flake.modules.flake.${componentName} = component;
}
