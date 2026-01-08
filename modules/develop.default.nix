{
  partitions.development.module = { inputs, ... }: {

    perSystem = { config, pkgs, ... }: {
      develop.default = {
        packages = [
          pkgs.just
        ];
      };
    };

  };
}
