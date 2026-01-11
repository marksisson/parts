let
  flakeModule = { options, self, ... }: {
    perSystem = { lib, pkgs, ... }:
      let
        flakeRoot = builtins.path { path = self; };

        recipe = pkgs.writeShellScriptBin "recipe" ''
          ${lib.getExe pkgs.just} --working-directory . --justfile ${flakeRoot}/justfile $(basename $0) "$@"
        '';

        justified = pkgs.runCommand "justified"
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
      { } // lib.optionalAttrs (options ? develop) {
        develop.default.packages = [ justified ];
      };
  };
in
{
  # import locally (dogfooding)
  imports = [ flakeModule ];
  # export via flakeModules
  flake.modules.flake.justified = flakeModule;
}
