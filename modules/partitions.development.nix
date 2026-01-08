{ inputs, lib, ... }:
let
  partition = "development";
in
{
  partitionedAttrs =
    lib.genAttrs
      [ "checks" "devShells" "formatter" ]
      (_: partition);

  partitions.${partition} =
    if inputs ? base then {
      extraInputsFlake =
        "github:marksisson/base/${inputs.base.rev}?dir=flakes/${partition}";
    } else {
      extraInputsFlake = ../flakes/${partition};
    };
}
