{
  description = "A collection of flake modules for various purposes.";

  outputs = inputs: with inputs.nixpkgs.lib; with inputs.flake-parts.lib;
    let imports = filter (n: strings.hasSuffix ".nix" n) (filesystem.listFilesRecursive ./modules);
    in mkFlake { inherit inputs; } { inherit imports; };

  inputs = {
    flake-parts.url = "https://flakehub.com/f/hercules-ci/flake-parts/0";
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0";
    systems.url = "github:nix-systems/default";
  };
}
