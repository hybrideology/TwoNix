{config, ...}: {
  flake.modules.nixos.base = {
    imports = [
      config.flake.modules.nixos.home-manager
      config.flake.modules.nixos.sops
      config.flake.modules.nixos.impermanence
      config.flake.modules.nixos.disko
      ../_/required
      ../_/auto-upgrade.nix
      ../_/clean-store.nix
      ../_/fail2ban.nix
      ../_/openssh.nix
      ../_/persistence.nix
      ../_/snowflake.nix
      ../_/systemd-boot.nix
    ];
  };
}
