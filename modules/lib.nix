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
        #components.nixology.flake.flake = component;
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

  builtinModule = { lib, ... }:
    {
      # this module is directly accessed from the builtinModule via the component,
      # so it needs to have a static key to facilitate deduplication
      key = "(import)github:nixology/flake#components.nixology.flake.lib.builtinModule";

      imports = [
        ./components.nix
        ./meta.nix
      ];

      # default systems
      systems = lib.mkDefault (import inputs.systems);

      # default pkgs
      perSystem = { system, ... }: {
        _module.args.pkgs = lib.mkDefault (builtins.seq inputs.nixpkgs inputs.nixpkgs.legacyPackages.${system});
      };
    };

  module = { lib, ... }: {
    # this module is directly accessed from the builtinModule via the component,
    # so it needs to have a static key to facilitate deduplication
    key = "(import)github:nixology/flake#components.nixology.flake.lib";

    options = with lib; with types; {
      flake.lib = mkOption {
        type = attrsOf (functionTo anything);
        default = { };
        description = "A set of utility functions and definitions.";
      };
    };

    config.flake.lib = lib.mkDefault library;
  };

  component = {
    inherit module;
  };
in
{
  flake.lib = library; # this is for lib access when imported directly (e.g. in this flake)
  imports = [ module ];
  components.nixology.flake.lib = component;
}
