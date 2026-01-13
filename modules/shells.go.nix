{ config, ... }: {
  flake.modules.flake.go = {
    imports = [ config.flake.modules.flake.shells ];

    perSystem = { pkgs, ... }: {
      shells.go = {
        packages = with pkgs; [
          go
          gotools
          golangci-lint
        ];
      };
    };
  };
}
