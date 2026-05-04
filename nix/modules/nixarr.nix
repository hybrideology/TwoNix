{inputs, ...}: {
  flake.nixosModules.nixarr = _: {
    imports = [inputs.nixarr.nixosModules.default];
  };
}
