{ inputs, ... }:
let
  module = {
    mkFlake = args: module:
      let
        builtinModule =
          {
            imports = [
              ./components.nix
              ./meta.nix
              ./nixology.nix
            ];

            # make the whole flake module a component
            nixology.components.flake = module;

            # default systems
            systems = import inputs.systems;

            # default pkgs
            perSystem = { system, ... }: {
              _module.args.pkgs = builtins.seq inputs.nixpkgs inputs.nixpkgs.legacyPackages.${system};
            };
          };
      in
      inputs.flake-parts.lib.mkFlake args { imports = [ module builtinModule ]; };

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

  component = {
    inherit module;
  };
in
{
  flake.lib = module;
  nixology.components.lib = component;
}
