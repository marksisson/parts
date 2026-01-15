{ config, ... }: {
  flake.modules.flake.nix =
    let
      _file = __curPos.file;
    in
    {
      inherit _file;
      key = _file;

      imports = [ config.flake.modules.flake.shells ];

      perSystem = { pkgs, ... }: {
        shells.default.packages = with pkgs; [
          nil
          nix-output-monitor
        ];
      };
    };
}
