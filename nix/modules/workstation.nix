{config, ...}: {
  flake.modules.nixos.workstation = {
    imports = [
      config.flake.modules.nixos.base
      config.flake.modules.nixos.bluetooth
      config.flake.modules.nixos.hyprland
      config.flake.modules.nixos.power
      config.flake.modules.nixos.pipewire
      config.flake.modules.nixos.printing
      config.flake.modules.nixos.steam
      config.flake.modules.nixos.wireguard-client
      config.flake.modules.nixos.networkmanager
    ];
  };
}
