{ inputs, ... }:
let
  mkFlake = args: module: inputs.flake-parts.lib.mkFlake args module;

  modulesIn = directory: with inputs.nixpkgs.lib; let
    moduleFiles =
      if filesystem.pathIsDirectory directory
      then
        (filter (n: strings.hasSuffix ".nix" n) (filesystem.listFilesRecursive directory))
      else
        [ ];
  in
  moduleFiles ++ [{ systems = import inputs.systems; }];
in
{
  flake.lib = {
    inherit mkFlake modulesIn;
  };
}
