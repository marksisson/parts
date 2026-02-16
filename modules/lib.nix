{ inputs, ... }:
let
  module = {
    imports = with inputs.std; [
      components.nixology.std.lib
    ];
  };

  component = {
    inherit module;
  };
in
{
  imports = [ module ];
  flake.components.nixology.parts.lib = component;
}
