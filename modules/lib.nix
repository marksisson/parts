{ inputs, ... }:
let
  localModule = {
    flake.lib = import ../lib inputs;
  };
in
{
  imports = [ localModule ];
}
