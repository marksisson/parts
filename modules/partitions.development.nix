{ inputs, ... }:
let
  partition = "development";
in
{
  imports = [ inputs.flake-parts.flakeModules.partitions ];

  partitionedAttrs = {
    checks = partition;
    devShells = partition;
    formatter = partition;
  };

  partitions.${partition}.extraInputsFlake = ../flakes/${partition};
}
