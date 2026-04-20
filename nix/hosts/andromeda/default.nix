{
  inputs,
  config,
  ...
}: {
  flake.nixosConfigurations.andromeda = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit inputs;
    };
    modules = [
      config.flake.modules.nixos.workstation
      {
        home-manager.extraSpecialArgs = {inherit inputs;};
        home-manager.users.will = import ./_/users/will.nix;
      }
      ./_/configuration.nix
    ];
  };
}
