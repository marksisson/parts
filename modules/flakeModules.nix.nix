{ config, ... }:
let
  flakeModule =
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
in
{
  flake.modules.flake.nix = flakeModule;
}
