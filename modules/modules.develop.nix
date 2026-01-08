{ flake-parts-lib, lib, ... }:
let
  module =
    {
      partitions.development.module = {

        options =
          let
            packages = lib.mkOption {
              type = lib.types.listOf lib.types.package;
              default = [ ];
              description = "List of packages to include in development shell.";
            };

            shellHook = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = "Shell hook script to run when entering the development shell.";
            };

            develop = lib.mkOption {
              type = lib.types.lazyAttrsOf (lib.types.submodule ({ name, ... }: {
                options = {
                  inherit packages shellHook;
                };
              }));
              default = { };
              description = "Development shell configuration.";
            };
          in
          {
            perSystem = flake-parts-lib.mkPerSystemOption {
              _file = ./modules.develop.nix;

              options = { inherit develop; };
            };
          };

        config = {
          perSystem = { config, pkgs, ... }: {
            devShells = lib.mapAttrs
              (name: develop: pkgs.mkShell {
                inherit (develop) packages shellHook;
              })
              config.develop;
          };
        };

      };
    };
in
{
  imports = [ module ];
  flake.modules.flake.default = module;
}
