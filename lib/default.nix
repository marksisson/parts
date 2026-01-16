inputs:
let
  mkFlake = args: module: inputs.flake-parts.lib.mkFlake args module;

  modulesIn = directory: with inputs.nixpkgs.lib; (
    filter (n: strings.hasSuffix ".nix" n) (filesystem.listFilesRecursive directory)
  ) ++ [{ systems = import inputs.systems; }];
in
{
  inherit mkFlake modulesIn;
}
