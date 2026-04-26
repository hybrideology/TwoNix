{...}: {
  imports = [
    ./disko.nix
    ./ddns.nix
    ./hardware.nix
    ./matrix-server.nix
    ./media-server.nix
    ./nginx.nix
    ./vars.nix
    ./vpn.nix
  ];
  time.timeZone = "America/Chicago";
  networking.hostName = "ceres";
  networking.hostId = "e0fdcfa7"; # random, required by zfs
  system.stateVersion = "25.11";
}
