{inputs, ...}: {
  imports = [
    ./disko.nix
    ./hardware.nix
  ];
  nixpkgs.hostPlatform = "x86_64-linux";
  time.timeZone = "America/Chicago";
  networking.hostName = "andromeda";
  networking.hostId = "10465c4e"; # random, required by zfs
  sops.secrets.personal_vpn_key.sopsFile = inputs.secrets.andromeda;
  system.stateVersion = "25.11";
  home-manager.users.will.home.stateVersion = "25.11";
  home-manager.users.will.vars.hyprland = {
    monitors = [
      "DP-4, 2560x1440@180, 0x0, 1, bitdepth, 10"
      "DP-5, 2560x1440@180, 2560x0, 1, bitdepth, 10"
      "HDMI-A-2, 1920x1080@144, 1600x-1080, 1"
    ];
    workspaces = [
      "1, default:true, monitor:DP-4"
      "2, default:true, monitor:HDMI-A-2"
      "3, default:true, monitor:DP-5"
    ];
  };
  vars.wireguard = {
    clientIp = "10.0.0.2";
    serverPublicKey = "QWwLEg0SjMm0ZNyb8iPa9V/29/VnHLKt9ZpVUaiE7j0=";
    endpoint = "465241395.xyz:51820";
  };
}
