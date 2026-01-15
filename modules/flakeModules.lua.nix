{ config, ... }: {
  flake.modules.flake.lua = {
    imports = [ config.flake.modules.flake.shells ];

    perSystem = { pkgs, ... }: {
      shells.default.packages = with pkgs; [
        lua5_1
      ];
    };
  };
}
