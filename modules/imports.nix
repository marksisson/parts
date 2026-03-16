{ inputs, ... }: {
  imports = with inputs.std.components; map (component: component.module) [
    nixology.std.components
    nixology.std.debug
    nixology.std.lib
    nixology.std.schemas
  ];
}
