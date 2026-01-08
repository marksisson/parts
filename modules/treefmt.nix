{
  partitions.development.module = { inputs, ... }: {

    imports = [ inputs.treefmt.flakeModule ];

    perSystem = { config, pkgs, ... }: {
      treefmt = {
        projectRootFile = "flake.nix";
        package = pkgs.treefmt;
        programs = {
          nixpkgs-fmt.enable = true;
          shfmt.enable = true;
        };
      };

      develop.default.packages = with config.treefmt; builtins.attrValues build.programs;
    };

  };
}
