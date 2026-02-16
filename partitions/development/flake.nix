{
  description = "private inputs for development purposes.";

  # this flake is only used for its inputs
  outputs = { ... }: { };

  inputs = {
    std-default.url = "git+ssh://git@github.com/marksisson/std?dir=partitions/default";

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "std-default/nixpkgs";
    };

    treefmt = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "std-default/nixpkgs";
    };
  };
}
