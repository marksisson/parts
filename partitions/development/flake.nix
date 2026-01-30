{
  description = "private inputs for development purposes.";

  # this flake is only used for its inputs
  outputs = { ... }: { };

  inputs = {
    # used for locking and following dependencies; do not access from parent flake
    main.url = "path:../..";

    # dev tools
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "main/nixpkgs";
    };

    treefmt = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "main/nixpkgs";
    };
  };
}
