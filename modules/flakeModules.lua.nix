{ config, ... }: {
  flake.modules.flake.lua =
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
}
