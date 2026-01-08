{ lib, ... }:
let
  module =
    { inputs, ... }:
    let
      partition = "development";
    in
    {
      partitionedAttrs =
        lib.genAttrs
          [ "checks" "devShells" "formatter" ]
          (_: partition);

      partitions.${partition} =
        if inputs ? flake then {
          extraInputsFlake =
            "github:marksisson/flake/${inputs.flake.rev}?dir=flakes/${partition}";
        } else {
          extraInputsFlake = ../flakes/${partition};
        };
    };
in
{
  imports = [ module ];
  flake.modules.flake.default = module;
}
