{
  inputs,
  config,
  ...
}: {
  flake.nixosConfigurations.betelgeuse = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {inherit inputs;};
    modules = [
      config.flake.modules.nixos.workstation
      config.flake.modules.nixos.will
      config.flake.modules.nixos.nvidia
      {sops.secrets.personal_vpn_key.sopsFile = inputs.secrets.betelgeuse;}
      {
        home-manager.users.will.imports = [config.flake.homeModules.earth];
        home-manager.users.will.home.stateVersion = "25.11";
      }
      ./_/configuration.nix
    ];
  };
}
