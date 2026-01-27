let
  module = { lib, ... }: {
    # this module is directly imported from the library function mkFlake
    # so it needs to have a static key to facilitate deduplication
    key = "(import)github:nixology/flake#components.nixology.nixology";

    options = with lib; with types;
      let
        nixology = mkOption
          {
            type = submoduleWith {
              modules = [
                {
                  freeformType = lazyAttrsOf (unique { inherit message; } raw);
                }
              ];
            };
            inherit description;
          };

        description = ''
          Raw attributes. Any attribute can be set here, but some
          attributes are represented by options, to provide appropriate
          configuration merging.
        '';

        message = ''
          No option has been declared for this attribute, so its definitions can't be merged automatically.
          Possible solutions:
            - Load a module that defines this attribute
            - Declare an option for this attribute
            - Make sure the attribute is spelled correctly
            - Define the value only once, with a single definition in a single module
        '';
      in
      {
        inherit nixology;
      };
  };

  component = {
    inherit module;
  };
in
{
  imports = [ module ];
  components.nixology.nixology = component;
}
