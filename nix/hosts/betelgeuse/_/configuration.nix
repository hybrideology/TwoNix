_: {
  imports = [
    ./disko.nix
    ./hardware.nix
    ./vpn.nix
    ./user.nix
  ];
  nixpkgs.hostPlatform = "x86_64-linux";
  time.timeZone = "America/Chicago";
  networking.hostName = "betelgeuse";
  networking.hostId = "1352f34a"; # random, required by zfs
  system.stateVersion = "25.11";
}
