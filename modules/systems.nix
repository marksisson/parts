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
  components.nixology.systems = component;
}
