{ inputs, ... }:
let
  library = {
    mkFlake = flakeArgs@{ name, ... }: flakeModule:
      let
        builtinModule =
          {
            # this module is directly accessed from the builtinModule via the component,
            # so it needs to have a static key to facilitate deduplication
            key = "(import)github:nixology/flake#components.lib.builtinModule";

            imports = [
              ./components.nix
              ./meta.nix
              ./nixology.nix
            ];

            nixology.meta.name = name;

            # default systems
            systems = import inputs.systems;

            # default pkgs
            perSystem = { system, ... }: {
              _module.args.pkgs = builtins.seq inputs.nixpkgs inputs.nixpkgs.legacyPackages.${system};
            };
          };

        module = {
          imports = [ flakeModule builtinModule ];
        };

        component = {
          inherit module;
        };

        args = builtins.removeAttrs flakeArgs [ "name" ];
      in
      inputs.flake-parts.lib.mkFlake args { imports = [ flakeModule builtinModule ]; nixology.components.flake = component; };

    modulesIn = directory: with inputs.nixpkgs.lib; let
      moduleFiles =
        if filesystem.pathIsDirectory directory
        then
          (filter (n: strings.hasSuffix ".nix" n) (filesystem.listFilesRecursive directory))
        else
          [ ];
    in
    moduleFiles;
  };

  module = { lib, ... }: {
    # this module is directly accessed from the builtinModule via the component,
    # so it needs to have a static key to facilitate deduplication
    key = "(import)github:nixology/flake#components.lib";

    options = with lib; with types; {
      flake.lib = mkOption {
        type = attrsOf (functionTo anything);
        default = { };
        description = "A set of utility functions and definitions.";
      };
    };

    config.flake.lib = library;
  };

  component = {
    inherit module;
  };
in
{
  flake.lib = library;
  nixology.components.lib = component;
}
