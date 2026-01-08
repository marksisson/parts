{
  description = "A collection of flake modules for various purposes.";

  outputs = inputs:
    let
      lib = inputs.nixpkgs.lib;
      imports = lib.filter (n: lib.strings.hasSuffix ".nix" n) (lib.filesystem.listFilesRecursive ./modules);
    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } { inherit imports; };

  inputs = {
    flake-parts.url = "https://flakehub.com/f/hercules-ci/flake-parts/0";
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0";
    systems.url = "github:nix-systems/default";
  };
}
