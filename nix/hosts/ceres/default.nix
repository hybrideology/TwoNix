{
  inputs,
  config,
  ...
}: {
  flake.nixosConfigurations.ceres = inputs.nixpkgs-small.lib.nixosSystem {
    specialArgs = {
      inherit inputs;
    };
    modules = [
      config.flake.modules.nixos.server
      {
        home-manager.extraSpecialArgs = {inherit inputs;};
        home-manager.users.will = import ./_/users/will.nix;
      }
      ./_/configuration.nix
    ];
  };
}
