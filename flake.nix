{
  description = "A collection of flake modules for various purposes.";

  inputs = {
    flake-parts.url = "https://flakehub.com/f/hercules-ci/flake-parts/0";
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0";
    nixpkgs-unstable.url = "https://flakehub.com/f/DeterminateSystems/nixpkgs-weekly/0";
    systems.url = "github:nix-systems/default";
    systems-darwin.url = "github:nix-systems/default-darwin";
    systems-linux.url = "github:nix-systems/default-darwin";
  };

  outputs = inputs:
    let name = "github:nixology/flake"; in
    with import ./modules/lib.nix { inherit inputs; }; with flake.lib;
    mkFlake { inherit inputs name; } { debug = true; imports = modulesIn ./modules; };
}
