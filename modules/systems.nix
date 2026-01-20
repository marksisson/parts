{ config, inputs, ... }:
let
  componentName = "systems";
  componentFile = __curPos.file;

  key = with config.meta; config.flake.lib.mkComponentKey { inherit flakeName flakeVersion componentName componentFile; };

  module = {
    systems = import inputs.systems;
  };

  component = {
    #inherit key;
    imports = [ module ];
  };
in
{
  flake.modules.flake.${componentName} = component;
}
