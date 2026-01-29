{ inputs, ... }:
let
  bundlersModule = inputs.flake-parts.flakeModules.bundlers;
  bundlersComponent = { module = bundlersModule; };

  easyOverlayModule = inputs.flake-parts.flakeModules.easyOverlay;
  easyOverlayComponent = { module = easyOverlayModule; };

  flakeModulesModule = inputs.flake-parts.flakeModules.flakeModules;
  flakeModulesComponent = { module = flakeModulesModule; };

  modulesModule = inputs.flake-parts.flakeModules.modules;
  modulesComponent = { module = modulesModule; };

  partitionsModule = inputs.flake-parts.flakeModules.partitions;
  partitionsComponent = { module = partitionsModule; };
in
{
  imports = [
    modulesModule
    partitionsModule
  ];

  flake.components.nixology.parts.bundlers = bundlersComponent;
  flake.components.nixology.parts.easyOverlay = easyOverlayComponent;
  flake.components.nixology.parts.flakeModules = flakeModulesComponent;
  flake.components.nixology.parts.modules = modulesComponent;
  flake.components.nixology.parts.partitions = partitionsComponent;
}
