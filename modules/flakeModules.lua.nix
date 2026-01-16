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
          lua5_1
        ];
      };
    };
in
{
  flake.modules.flake.lua = flakeModule;
}
