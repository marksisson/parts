{ inputs, ... }:
let
  module =
    {
      systems = import inputs.systems;
    };
in
{
  imports = [ module ];
  flake.modules.flake.default = module;
}
