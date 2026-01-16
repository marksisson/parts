{ inputs, ... }:
let
  partition = "development";

  localModule = {
    partitionedAttrs = {
      checks = partition;
      devShells = partition;
      formatter = partition;
    };

    partitions.${partition}.extraInputsFlake = ../partitions/${partition};
  };
in
{
  imports = [ localModule ];
}
