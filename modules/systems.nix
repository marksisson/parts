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
  nixology.components.systems = component;
}
