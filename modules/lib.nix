{ inputs, ... }:
let
  library = {
    mkFlake = flakeArgs@{ flakeref, ... }: flakeModule:
      let
        args = builtins.removeAttrs flakeArgs [ "flakeref" ];
        module = { imports = [ flakeModule builtinModule ]; };
      in
      inputs.flake-parts.lib.mkFlake args {
        imports = [ module { flake.meta.flakeref = flakeref; } ];
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
      # default systems
      systems = lib.mkDefault (import inputs.systems);

      # default pkgs
      perSystem = { system, ... }: {
        _module.args.pkgs = lib.mkDefault (builtins.seq inputs.nixpkgs inputs.nixpkgs.legacyPackages.${system});
      };
    };

  module = { lib, ... }: {
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
  flake.components.nixology.parts.lib = component;
}
