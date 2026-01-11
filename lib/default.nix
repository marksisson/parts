nixpkgs-lib: flake-parts-lib:
let
  mkFlake = args: module:
    let
      specialArgs = { };
    in
    flake-parts-lib.mkFlake (args // { inherit specialArgs; }) module;

  modulesIn = directory: with nixpkgs-lib; filter (n: strings.hasSuffix ".nix" n) (filesystem.listFilesRecursive directory);
in
{
  inherit mkFlake modulesIn;
}
