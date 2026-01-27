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
    flakeModulesModule
    modulesModule
    partitionsModule
  ];

  components.nixology.parts.bundlers = bundlersComponent;
  components.nixology.parts.easyOverlay = easyOverlayComponent;
  components.nixology.parts.flakeModules = flakeModulesComponent;
  components.nixology.parts.modules = modulesComponent;
  components.nixology.parts.partitions = partitionsComponent;
}
