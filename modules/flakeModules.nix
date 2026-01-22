{ config, ... }:
let
  module = {
    flake.flakeModules = config.flake.modules.flake //
      { default = config.flake.modules.flake.systems; };
  };
in
module
