{ inputs, ... }:
{
  flake.lib = import ../lib inputs.nixpkgs.lib inputs.flake-parts.lib;
}
