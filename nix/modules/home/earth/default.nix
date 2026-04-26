{inputs, ...}: {
  flake.homeModules.earth = {
    imports = [
      inputs.stylix.homeModules.stylix
      ../_/earth
    ];
  };
}
