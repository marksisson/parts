{ config, ... }:
let
  module = {
    flake.flakeModules = config.nixology.components //
      { default = config.nixology.components.flake; };
  };
in
module
