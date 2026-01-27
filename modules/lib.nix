{ inputs, ... }:
let
  library = {
    mkFlake = flakeArgs@{ name, ... }: flakeModule:
      let
        args = builtins.removeAttrs flakeArgs [ "name" ];
        module = { imports = [ flakeModule builtinModule ]; };
        component = { module = flakeModule; };
      in
      inputs.flake-parts.lib.mkFlake args {
        imports = [ module { meta.name = name; } ];
        #components.nixology.flake = component;
      };

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

  builtinModule =
    {
      # this module is directly accessed from the builtinModule via the component,
      # so it needs to have a static key to facilitate deduplication
      key = "(import)github:nixology/flake#components.nixology.lib.builtinModule";

      imports = [
        ./components.nix
        ./meta.nix
        ./nixology.nix
      ];

      # default systems
      systems = import inputs.systems;

      # default pkgs
      perSystem = { system, ... }: {
        _module.args.pkgs = builtins.seq inputs.nixpkgs inputs.nixpkgs.legacyPackages.${system};
      };
    };

  module = { lib, ... }: {
    # this module is directly accessed from the builtinModule via the component,
    # so it needs to have a static key to facilitate deduplication
    key = "(import)github:nixology/flake#components.nixology.lib";

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
  components.nixology.lib = component;
}
