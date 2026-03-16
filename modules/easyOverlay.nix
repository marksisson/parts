{ inputs, ... }:
let
  module = with inputs.std.inputs.flake-parts.flakeModules; {
    imports = [ easyOverlay ];
  };

  component = {
    inherit module;
    dependencies = with inputs.self.components; [
      nixology.std.schemas
    ];
    meta = {
      shortDescription = "module for easy overlay management";
    };
  };
in
{
  flake.components = { nixology.parts.easyOverlay = component; };
}
