{
  inputs,
  config,
  ...
}: {
  flake.nixosConfigurations.ceres = inputs.nixpkgs-small.lib.nixosSystem {
    specialArgs = {inherit inputs;};
    modules = [
      config.flake.modules.nixos.ceres
      config.flake.modules.nixos.server
      config.flake.modules.nixos.wireguard-server
      config.flake.modules.nixos.i2pd
      config.flake.modules.nixos.will
      config.flake.modules.nixos.nixarr
    ];
  };
}
