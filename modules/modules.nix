{ inputs, ... }:
let
  module = inputs.flake-parts.flakeModules.modules;

  component = {
    key = "E5AB2389-86CC-427B-938A-5438F6A27DD6";

    imports = [
      module
    ];
  };
in
{
  imports = [ module ];
  flake.modules.flake.modules = component;
}
