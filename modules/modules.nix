{ inputs, ... }:
let
  localModule = {
    imports = [ inputs.flake-parts.flakeModules.modules ];
  };

  flakeModule = {
    key = "E5AB2389-86CC-427B-938A-5438F6A27DD6";

    imports = [
      localModule
    ];
  };
in
{
  imports = [ localModule ];
  flake.modules.flake.modules = flakeModule;
}
