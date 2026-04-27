{inputs, ...}: {
  flake.modules.nixos.nixarr = _: {
    imports = [inputs.nixarr.nixosModules.default];
  };
}
