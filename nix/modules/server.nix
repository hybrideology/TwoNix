{config, ...}: {
  flake.modules.nixos.server = {
    imports = [
      config.flake.modules.nixos.base
      config.flake.modules.nixos.dataDirs
      config.flake.modules.nixos.i2pd
    ];
  };
}
