{inputs, ...}: {
  flake.modules.nixos.impermanence = _: {
    imports = [inputs.impermanence.nixosModules.impermanence];
  };
}
