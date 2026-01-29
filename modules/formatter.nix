{ config, ... }:
let
  module =
    let
      # capture partition inputs from config of outer flake
      # so that is is part of the component
      inputs = config.partitions.development.extraInputs;
    in
    {
      imports = [ inputs.treefmt.flakeModule ];
      perSystem = { config, pkgs, ... }:
        {
          treefmt =
            {
              projectRootFile = "flake.nix";
              package = pkgs.treefmt;
              programs = {
                nixpkgs-fmt.enable = true;
                shfmt.enable = true;
              };
            };

          shells.default.packages = with config.treefmt; builtins.attrValues build.programs;
        };
    };

  partitionedModule = {
    partitions.development = { inherit module; };
  };

  component = {
    inherit module;
    dependencies = with config.flake; [
      components.nixology.parts.shells
      components.nixology.parts.systems
    ];
  };
in
{
  imports = [ partitionedModule ];
  flake.components.nixology.parts.formatter = component;
}
