{
  partitions.development.module = { inputs, ... }: {

    imports = [ inputs.git-hooks.flakeModule ];

    perSystem = { config, ... }: {
      pre-commit.settings.hooks = {
        treefmt.enable = true;
        treefmt.package = config.treefmt.build.wrapper;
      };

      develop.default.packages = with config.pre-commit; settings.enabledPackages;

      develop.default.shellHook = ''
        ${with config.pre-commit; shellHook}
      '';
    };

  };
}
