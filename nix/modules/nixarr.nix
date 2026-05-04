{inputs, ...}: {
  flake.nixosModules.nixarr = {config, ...}: {
    imports = [inputs.nixarr.nixosModules.default];
  };
}
