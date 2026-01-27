{ config, ... }:
let
  components = config.components;

  module = { config, lib, ... }:
    let
      componentSets =
        builtins.concatLists (
          map builtins.attrValues
            (builtins.attrValues config.components)
        );

      components =
        lib.foldl' lib.recursiveUpdate { } componentSets;
    in
    {
      flake.flakeModules = components //
        { default = { imports = builtins.attrValues config.components.nixology.flake; }; };
    };

  component = {
    inherit module;
    dependencies = [
      components.nixology.parts.flakeModules
      components.nixology.flake.components
    ];
  };
in
{
  imports = [ module ];
  components.nixology.flake.flakeModules = component;
}
