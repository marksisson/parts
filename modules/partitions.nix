local@{ inputs, ... }:
let
  flakeModule =
    {
      imports = [ inputs.flake-parts.flakeModules.partitions ];
    };
in
{
  # import locally (dogfooding)
  imports = [ flakeModule ];
  # export via flakeModules
  flake.modules.flake.partitions = flakeModule;
}
