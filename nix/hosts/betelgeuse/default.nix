{
  inputs,
  config,
  ...
}: {
  flake.nixosConfigurations.betelgeuse = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {inherit inputs;};
    modules = [
      config.flake.modules.nixos.betelgeuse
      config.flake.modules.nixos.workstation
      config.flake.modules.nixos.will
      config.flake.modules.nixos.nvidia
    ];
  };
}
