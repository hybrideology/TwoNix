_: {
  imports = [
    ./disko.nix
    ./hardware.nix
    ./vpn.nix
    ./user.nix
  ];
  nixpkgs.hostPlatform = "x86_64-linux";
  time.timeZone = "America/Chicago";
  networking.hostName = "andromeda";
  networking.hostId = "10465c4e"; # random, required by zfs
  system.stateVersion = "25.11";
}
