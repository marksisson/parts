{ config, lib, ... }:
let
  # make all the modules available except for flakeModules
  imports = lib.filter
    (path:
      lib.strings.hasSuffix ".nix" path
      && !lib.strings.hasPrefix "flakeModules" (baseNameOf path)
    )
    (lib.filesystem.listFilesRecursive ./.);
in
{
  flake.flakeModules.default = { inherit imports; };
}
