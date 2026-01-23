{ inputs, ... }:
let
  module = {
    mkFlake = flakeArgs@{ name, ... }: flakeModule:
      let
        builtinModule = {
          imports = [
            ./components.nix
            ./meta.nix
            ./nixology.nix
          ];
          nixology.meta.flake = { inherit name module; };
          systems = import inputs.systems;
        };

        args = builtins.removeAttrs flakeArgs [ "name" ];

        module = {
          imports = [ flakeModule builtinModule ];
        };
      in
      inputs.flake-parts.lib.mkFlake args module;

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

  component = module;
in
{
  flake.lib = module;
  flake.modules.flake.lib = component;
}
