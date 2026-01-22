{ config, inputs, ... }:
{
  imports = [
    inputs.flake-parts.flakeModules.flakeModules
    inputs.flake-parts.flakeModules.modules
    inputs.flake-parts.flakeModules.partitions
  ];

  partitions.development.module = {
    imports = let inputs = config.partitions.development.extraInputs; in [
      inputs.git-hooks.flakeModule
      inputs.treefmt.flakeModule
    ];
  };
}
