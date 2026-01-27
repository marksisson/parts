{ config, ... }:
let
  components = config.components;

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
    dependencies = [
      components.nixology.flake.shells
      components.nixology.flake.systems
    ];
  };
in
{
  imports = [ partitionedModule ];
  components.nixology.flake.formatter = component;
}
