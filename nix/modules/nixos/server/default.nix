{config, ...}: {
  flake.modules.nixos.server = {
    imports = [
      config.flake.modules.nixos.base
      ../_/i2pd.nix
    ];
  };
}
