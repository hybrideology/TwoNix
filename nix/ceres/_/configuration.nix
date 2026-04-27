_: {
  imports = [
    ./disko.nix
    ./ddns.nix
    ./dns.nix
    ./hardware.nix
    ./matrix-server.nix
    ./media-server.nix
    ./nginx.nix
    ./vpn.nix
    ./user.nix
  ];
  nixpkgs.hostPlatform = "x86_64-linux";
  time.timeZone = "America/Chicago";
  networking.hostName = "ceres";
  networking.hostId = "e0fdcfa7"; # random, required by zfs
  system.stateVersion = "25.11";
}
