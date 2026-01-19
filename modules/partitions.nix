{ inputs, ... }:
let
  localModule = {
    imports = [ inputs.flake-parts.flakeModules.partitions ];
  };

  flakeModule = {
    key = "1FB22DC2-6320-498F-8DD2-F3634F0C460A";

    imports = [
      localModule
    ];
  };
in
{
  imports = [ localModule ];
  flake.modules.flake.partitions = flakeModule;
}
