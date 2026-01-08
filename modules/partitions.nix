{ inputs, ... }:
let
  module =
    {
      imports = [ inputs.flake-parts.flakeModules.partitions ];
    };
in
{
  imports = [ module ];
  flake.modules.flake.default = module;
}
