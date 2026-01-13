local@{ inputs, ... }:
let
  flakeModule =
    {
      systems = import inputs.systems;
    };
in
{
  # import locally (dogfooding)
  imports = [ flakeModule ];
  # export via flakeModules
  flake.modules.flake.systems = flakeModule;
}
