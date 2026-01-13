{ config, inputs, ... }: {
  imports = [ inputs.flake-parts.flakeModules.flakeModules ];

  # export all flake modules under flake.modules.flake
  flake.flakeModules = config.flake.modules.flake // { default = config.flake.modules.flake.systems; };
}
