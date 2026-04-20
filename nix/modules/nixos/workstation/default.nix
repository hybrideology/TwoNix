_: {
  flake.modules.nixos.workstation = _: {
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
      ../_/bluetooth.nix
      ../_/hyprland.nix
      ../_/pipewire.nix
      ../_/printing.nix
      ../_/steam.nix
      ../_/wireless.nix
    ];
  };
}
