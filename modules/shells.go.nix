{
  flake.modules.flake.go = {
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
