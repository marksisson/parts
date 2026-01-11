let
  flakeModule = {
    debug = true;
  };
in
{
  # import locally (dogfooding)
  imports = [ flakeModule ];
  # export via flakeModules
  flake.modules.flake.debug = flakeModule;
}
