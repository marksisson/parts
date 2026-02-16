{ inputs, ... }:
let
  # define components for flake-parts modules
  parts = with inputs.std.inputs.flake-parts; {
    bundlers = { module = flakeModules.bundlers; };
    easyOverlay = { module = flakeModules.easyOverlay; };
    flakeModules = { module = flakeModules.flakeModules; };
    modules = { module = flakeModules.modules; };
    partitions = { module = flakeModules.partitions; };
  };
in
{
  imports = [
    parts.modules.module
    parts.partitions.module
  ];

  flake.components.nixology = { inherit parts; };
}
