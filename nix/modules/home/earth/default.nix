{inputs, ...}: {
  flake.homeModules.earth = {
    imports = [
      inputs.noctalia-shell.homeModules.default
      ../_/earth
    ];
  };
}
