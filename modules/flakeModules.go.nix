{ config, ... }: {
  flake.modules.flake.go =
    let
      _file = __curPos.file;
    in
    {
      inherit _file;
      key = _file;

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
