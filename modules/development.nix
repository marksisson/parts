{ lib, ... }:
let
  developement = let partition = "development"; in {
    partitionedAttrs = lib.genAttrs [ "checks" "devShells" "formatter" ] (_: partition);
    partitions.${partition}.extraInputsFlake = ../partitions/${partition};
  };

  schemas = let partition = "schemas"; in {
    partitions.${partition}.extraInputsFlake = ../partitions/${partition};
  };

  module = {
    imports = [ developement schemas ];
  };
in
module
