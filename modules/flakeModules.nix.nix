{ config, ... }: {
  flake.modules.flake.nix = {
    imports = [ config.flake.modules.flake.shells ];

    perSystem = { pkgs, ... }: {
      shells.default.packages = with pkgs; [
        nil
        nix-output-monitor
      ];
    };
  };
}
