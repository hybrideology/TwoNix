{config, ...}: {
  flake.modules.nixos.workstation = {
    imports = [
      config.flake.modules.nixos.base
      ../_/bluetooth.nix
      ../_/hyprland.nix
      ../_/pipewire.nix
      ../_/printing.nix
      ../_/steam.nix
      ../_/wireless.nix
    ];
  };
}
