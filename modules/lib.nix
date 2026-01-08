{ inputs, lib, ... }:
let
  module = {
    flake.lib.modulesIn = directory: lib.filter (n: lib.strings.hasSuffix ".nix" n) (lib.filesystem.listFilesRecursive directory);
    flake.lib.mkFlake = inputs.flake-parts.lib.mkFlake;
  };
in
{
  imports = [ module ];
  flake.modules.flake.flake = module;
}
