{ config, ... }: {
  flake.modules.flake.go = {
    imports = [ config.flake.modules.flake.shells ];

    perSystem = { pkgs, ... }: {
      shells.default.packages = with pkgs; [
        go
        gotools
        golangci-lint
      ];
    };
  };
}
