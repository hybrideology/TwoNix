{inputs, ...}: {
  flake.nixosModules.impermanence = _: {
    imports = [inputs.impermanence.nixosModules.impermanence];
  };
}
