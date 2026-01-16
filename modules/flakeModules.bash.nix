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
          nodePackages.bash-language-server
          shellcheck
        ];
      };
    };
in
{
  flake.modules.flake.bash = flakeModule;
}
