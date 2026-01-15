{ inputs, ... }:
let
  flakeModule =
    {
      imports = [ inputs.flake-parts.flakeModules.modules ];
    };
in
{
  # import locally (dogfooding)
  imports = [ flakeModule ];
  # export via flakeModules
  flake.modules.flake.modules = flakeModule;
}
