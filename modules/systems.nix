{ inputs, ... }:
let
  module = {
    systems = import inputs.systems;
  };

  component = {
    inherit module;
  };
in
{
  flake.components.nixology.parts.systems = component;
}
