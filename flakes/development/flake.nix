{
  description = "private inputs for development purposes.";

  # this flake is only used for its inputs
  outputs = { ... }: { };

  inputs = {
    main.url = "path:../..";

    # dev tools
    git-hooks = {
      url = "https://flakehub.com/f/cachix/git-hooks.nix/0";
      inputs.nixpkgs.follows = "main/nixpkgs";
    };

    treefmt = {
      url = "https://flakehub.com/f/numtide/treefmt-nix/0";
      inputs.nixpkgs.follows = "main/nixpkgs";
    };
  };
}
