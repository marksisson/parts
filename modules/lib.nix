{ inputs, ... }:
let
  module = {
    mkFlake = args: module: inputs.flake-parts.lib.mkFlake args {
      imports = [ module { systems = import inputs.systems; } ];
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

  component = module;
in
{
  flake.lib = module;
  flake.modules.flake.lib = component;
}
