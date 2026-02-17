{ lib, ... }:
let
  module = let partition = "development"; in {
    partitionedAttrs = lib.genAttrs [ "checks" "devShells" "formatter" ] (_: partition);
    partitions.${partition}.extraInputsFlake = ../partitions/${partition};
  };
in
module
