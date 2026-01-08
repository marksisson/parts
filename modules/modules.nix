{ inputs, ... }:
let
  module =
    {
      imports = [ inputs.flake-parts.flakeModules.modules ];
    };
in
{
  imports = [ module ];
  flake.modules.flake.default = module;
}
