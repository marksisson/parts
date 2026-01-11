{
  perSystem = { pkgs, ... }: {
    develop.default = {
      packages = [ pkgs.just ];
    };
  };
}
