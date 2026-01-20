{ config, inputs, ... }:
let
  componentName = "modules";
  componentFile = __curPos.file;

  key = with config.meta; config.flake.lib.mkComponentKey { inherit flakeName flakeVersion componentName componentFile; };

  module = inputs.flake-parts.flakeModules.modules;

  component = {
    inherit key;
    imports = [ module ];
  };
in
{
  imports = [ module ];
  flake.modules.flake.${componentName} = component;
}
