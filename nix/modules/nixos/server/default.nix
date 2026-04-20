_: {
  flake.modules.nixos.server = _: {
    imports = [
      ../_/required
      ../_/auto-upgrade.nix
      ../_/clean-store.nix
      ../_/fail2ban.nix
      ../_/home-manager.nix
      ../_/openssh.nix
      ../_/persistence.nix
      ../_/snowflake.nix
      ../_/systemd-boot.nix
      ../_/i2pd.nix
    ];
  };
}
