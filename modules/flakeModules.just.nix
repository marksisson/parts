{ config, ... }:
let
  localModule = { self, ... }: {
    perSystem = { lib, pkgs, ... }:
      let
        flakeRoot = builtins.path { path = self; };

        recipe = pkgs.writeShellScriptBin "recipe" ''
          ${lib.getExe pkgs.just} --working-directory . --justfile ${flakeRoot}/justfile $(basename $0) "$@"
        '';

        just-aliases = pkgs.runCommand "just-aliases"
          {
            src = flakeRoot;
            buildInputs = with pkgs; [ coreutils findutils gawk just ];
          } ''
          mkdir -p $out/bin
          just --summary --justfile $src/justfile | xargs -n1 | awk -F: '{print $1}' | uniq | while read -r name; do
            ln -s ${lib.getExe recipe} $out/bin/$name
          done
        '';
      in
      {
        shells.default.packages = [ pkgs.just just-aliases ];
      };
  };

  flakeModule = { self, ... }: {
    imports = [ config.flake.modules.flake.shells ];
  } // localModule { inherit self; };
in
{
  # import locally (dogfooding)
  imports = [ localModule ];
  # export via flakeModules
  flake.modules.flake.just = flakeModule;
}
