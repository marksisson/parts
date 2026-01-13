{
  perSystem = { pkgs, ... }: {
    shells.default.packages = [ pkgs.just ];
  };
}
