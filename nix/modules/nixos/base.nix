{config, ...}: {
  flake.modules.nixos.base = {
    imports = [
      config.flake.modules.nixos.home-manager
      config.flake.modules.nixos.sops
      config.flake.modules.nixos.impermanence
      config.flake.modules.nixos.disko
      config.flake.modules.nixos.environment
      config.flake.modules.nixos.groups
      config.flake.modules.nixos.nix
      config.flake.modules.nixos.nixpkgs
      config.flake.modules.nixos.sops-defaults
      config.flake.modules.nixos.vars
      config.flake.modules.nixos.auto-upgrade
      config.flake.modules.nixos.clean-store
      config.flake.modules.nixos.fail2ban
      config.flake.modules.nixos.openssh
      config.flake.modules.nixos.persistence
      config.flake.modules.nixos.snowflake
      config.flake.modules.nixos.systemd-boot
    ];
  };
}
