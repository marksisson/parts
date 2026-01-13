let
  flakeModule = { flake-parts-lib, lib, ... }: {
    _file = ./shells.nix;

    key = _file;

    options =
      let
        inputsFrom = lib.mkOption {
          type = lib.types.listOf lib.types.package;
          default = [ ];
          description = "List of packages whose inputs will be included in the development shell.";
        };

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

        shells = lib.mkOption {
          type = lib.types.lazyAttrsOf (lib.types.submodule ({ name, ... }: {
            options = {
              name = lib.mkOption {
                type = lib.types.str;
                default = name;
                description = "Name of the development shell.";
              };
              inherit inputsFrom packages shellHook;
            };
          }));
          default = { };
          description = "Development shell configurations.";
        };
      in
      {
        perSystem = flake-parts-lib.mkPerSystemOption {
          _file = ./shells.nix;

          options = { inherit shells; };
        };
      };

    config = {
      perSystem = { config, pkgs, ... }: {
        devShells = lib.mapAttrs
          (name: shell: pkgs.mkShell {
            inherit (shell) inputsFrom name packages shellHook;
          })
          config.shells;
      };
    };
  };
in
{
  # import locally (dogfooding)
  imports = [ flakeModule ];
  # export via flakeModules
  flake.modules.flake.shells = flakeModule;
}
