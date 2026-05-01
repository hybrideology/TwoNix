{inputs, ...}: {
  flake.nixosModules.disko = _: {
    imports = [inputs.disko.nixosModules.disko];
  };
}
