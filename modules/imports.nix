{ config, inputs, ... }:
let
  module = {
    imports = [
      inputs.flake-parts.flakeModules.flakeModules
      inputs.flake-parts.flakeModules.modules
      inputs.flake-parts.flakeModules.partitions
    ];

    partitions.development.module = { inputs, ... }: {
      imports = [
        inputs.git-hooks.flakeModule
        inputs.treefmt.flakeModule
      ];
    };
  };
in
{
  # nb. by putting module in imports, we ensure that it closes over the inputs
  imports = [ module ];
}
