let
  module = {
    debug = true;
  };
in
{
  imports = [ module ];
  flake.modules.flake.default = module;
}
