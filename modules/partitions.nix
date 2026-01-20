{ inputs, ... }:
let
  module = inputs.flake-parts.flakeModules.partitions;

  component = {
    key = "1FB22DC2-6320-498F-8DD2-F3634F0C460A";

    imports = [
      module
    ];
  };
in
{
  imports = [ module ];
  flake.modules.flake.partitions = component;
}
