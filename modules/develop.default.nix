let
  moduleWithOptionalPartitionedAttr =
    partitionedAttr: moduleConfig:

    { config, lib, ... }:
    let
      isPartitioned = config.partitionedAttrs ? ${partitionedAttr};
      partition = config.partitionedAttrs.${partitionedAttr} or null;
    in
    {
      config = lib.mkMerge [
        (lib.mkIf isPartitioned {
          partitions.${partition}.module = moduleConfig;
        })

        (lib.mkIf (!isPartitioned) moduleConfig)
      ];
    };

  module =
    moduleWithOptionalPartitionedAttr "devShells" {
      perSystem = { pkgs, ... }: {
        develop.default = {
          packages = [ pkgs.just ];
        };
      };
    };

in
{
  imports = [ module ];
  flake.modules.flake.default = module;
}
