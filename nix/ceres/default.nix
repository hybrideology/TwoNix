{
  inputs,
  config,
  ...
}: {
  flake.nixosConfigurations.ceres = inputs.nixpkgs-small.lib.nixosSystem {
    specialArgs = {inherit inputs;};
    modules = [
      config.flake.modules.nixos.server
      config.flake.modules.nixos.will
      config.flake.modules.nixos.nixarr
      {
        home-manager.users.will.imports = [config.flake.homeModules.desolate];
      }
      ./_/configuration.nix
    ];
  };
}
