{ config, self, ... }:
let
  componentName = "git-hooks";
  componentFile = __curPos.file;

  key = with config.meta; config.flake.lib.mkComponentKey { inherit flakeName flakeVersion componentName componentFile; };

  module =
    let
      # Get extra inputs from the development partition
      inputs = config.partitions.development.extraInputs;
    in
    inputs.git-hooks.flakeModule;

  partitionedModule = {
    partitions.development.module = module;
  };

  component = {
    #inherit key;
    imports = [ module ];
  };
in
{
  imports = [ partitionedModule ];
  flake.modules.flake.${componentName} = component;
}
