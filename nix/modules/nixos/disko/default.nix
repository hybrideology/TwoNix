{inputs, ...}: {
  flake.modules.nixos.disko = _: {
    imports = [inputs.disko.nixosModules.disko];
  };
}
