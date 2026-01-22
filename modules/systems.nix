{ inputs, ... }:
let
  module = {
    systems = import inputs.systems;
  };

  component = module;
in
{
  flake.modules.flake.systems = component;
}
