{ config, ... }:
let
  flakeModule = let _file = __curPos.file; key = _file; in {
    inherit _file key;

    imports = [ config.flake.modules.flake.shells ];

    perSystem = { pkgs, ... }: with pkgs; {
      shells.default.packages = [ nil nix-output-monitor ];
    };
  };
in
{
  flake.modules.flake.nix = flakeModule;
}
