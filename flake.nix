{
  description = "A collection of flake components for various purposes.";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:nixos/nixpkgs";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
    systems-darwin.url = "github:nix-systems/default-darwin";
    systems-linux.url = "github:nix-systems/default-darwin";
  };

  outputs = inputs:
    let flakeref = "github:nixology/parts"; in
    with import ./modules/lib.nix { inherit inputs; }; with flake.lib;
    mkFlake { inherit flakeref inputs; } { debug = true; imports = modulesIn ./modules; };
}
