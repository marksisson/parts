inputs:
let
  nixpkgs-lib = inputs.nixpkgs.lib;
  flake-parts-lib = inputs.flake-parts.lib;

  mkFlake = args: module:
    let
      specialArgs = { };
    in
    flake-parts-lib.mkFlake (args // { inherit specialArgs; }) module;

  modulesIn = directory: with nixpkgs-lib; (
    filter (n: strings.hasSuffix ".nix" n) (filesystem.listFilesRecursive directory)
  ) ++ [{ systems = import inputs.systems; }];
in
{
  inherit mkFlake modulesIn;
}
