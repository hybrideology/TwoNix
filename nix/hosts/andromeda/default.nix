{
  inputs,
  config,
  ...
}: {
  flake.modules.nixos.andromeda = {
    imports = [
      inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
      config.flake.modules.nixos.workstation
      config.flake.modules.nixos.will
      config.flake.modules.nixos.nvidia
      {sops.secrets.personal_vpn_key.sopsFile = inputs.secrets.andromeda;}
      {home-manager.users.will.imports = [config.flake.homeModules.earth];
       home-manager.users.will.home.stateVersion = "25.11";}
      ./_/configuration.nix
    ];
  };

  configurations.nixos.andromeda.module = config.flake.modules.nixos.andromeda;
}
