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
  flake.components.nixology.environments.lib = component;
}
