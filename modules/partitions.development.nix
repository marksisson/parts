let
  partition = "development";
in
{
  partitionedAttrs = {
    checks = partition;
    devShells = partition;
    formatter = partition;
  };

  partitions.${partition}.extraInputsFlake = ../flakes/${partition};
}
