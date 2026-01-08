{ inputs, ... }:
let
  module =
    {
      imports = [ inputs.flake-parts.flakeModules.flakeModules ];
    };
in
{
  imports = [ module ];
  flake.modules.flake.flake = module;
}
