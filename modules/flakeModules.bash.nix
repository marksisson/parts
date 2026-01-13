{ config, ... }: {
  flake.modules.flake.bash = {
    imports = [ config.flake.modules.flake.shells ];

    perSystem = { pkgs, ... }: {
      shells.default.packages = with pkgs; [
        nodePackages.bash-language-server
        shellcheck
      ];
    };
  };
}
