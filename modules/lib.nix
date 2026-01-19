{ inputs, ... }:
let
  defaultModules = [
    { systems = import inputs.systems; }
  ];

  mkFlake = args: module: inputs.flake-parts.lib.mkFlake args { imports = [ module ] ++ defaultModules; };

  mkModuleKey = { flakeName, flakeVersion, moduleName, moduleFile, ... }:
    with inputs.nixpkgs.lib; let
      relativeModuleFile = concatStringsSep "/" (drop 4 (splitString "/" moduleFile));
    in
    "${flakeName}/${relativeModuleFile}?flakeModule=${moduleName}@${flakeVersion}";

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
    inherit mkFlake mkModuleKey modulesIn;
  };
}
