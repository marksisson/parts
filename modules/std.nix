{ inputs, ... }: {
  imports = with inputs.std; [
    components.nixology.std.components
    components.nixology.std.meta
  ];

  flake.components = inputs.std.components;
}
