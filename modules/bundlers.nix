{ inputs, ... }:
let
  module = with inputs.std.inputs.flake-parts.flakeModules; {
    imports = [ bundlers ];
    config = { flake.schemas.bundlers = schema; };
  };

  schema = {
    version = 1;
    doc = ''
      The `bundlers` flake output contains functions that return a bundle that works outside of the Nix store.
    '';
    inventory = _output: { what = "bundler"; };
  };

  component = {
    inherit module;
    dependencies = with inputs.self.components; [
      nixology.std.schemas
    ];
    meta = {
      shortDescription = "functions that return bundled applications";
    };
  };
in
{
  flake.components = { nixology.parts.bundlers = component; };
}
