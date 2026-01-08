{ config, lib, ... }:
let
  module =
    {
      flake.flakeModules.default = config.flake.modules.flake.default;
    };
in
{
  imports = [ module ];
  flake.modules.flake.flake = module;
}
