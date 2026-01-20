{ inputs, ... }:
let
  defaultModules = [
    { systems = import inputs.systems; }
  ];

  mkFlake = args: module: inputs.flake-parts.lib.mkFlake args { imports = [ module ] ++ defaultModules; };

  mkComponentKey = { flakeName, flakeVersion, componentName, componentFile, ... }:
    with inputs.nixpkgs.lib; let
      relativeComponentFile = concatStringsSep "/" (drop 4 (splitString "/" componentFile));
    in
    "${flakeName}/${relativeComponentFile}?component=${componentName}@${flakeVersion}";

  modulesIn = directory: with inputs.nixpkgs.lib; let
    moduleFiles =
      if filesystem.pathIsDirectory directory
      then
        (filter (n: strings.hasSuffix ".nix" n) (filesystem.listFilesRecursive directory))
      else
        [ ];
  in
  moduleFiles;
in
{
  flake.lib = {
    inherit
      mkFlake
      mkComponentKey
      modulesIn;
  };
}
