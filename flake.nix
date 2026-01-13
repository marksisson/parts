{
  description = "A collection of flake modules for various purposes.";

  inputs = {
    flake-parts.url = "https://flakehub.com/f/hercules-ci/flake-parts/0";
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0";
    nixpkgs-unstable.url = "https://flakehub.com/f/DeterminateSystems/nixpkgs-weekly/0";
    systems.url = "github:nix-systems/default";
  };

  outputs = inputs: with import ./lib inputs;
    mkFlake { inherit inputs; } { imports = modulesIn ./modules; };
}
