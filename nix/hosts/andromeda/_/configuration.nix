{...}: {
  imports = [
    ./disko.nix
    ./hardware.nix
    ./users.nix
    ./vpn.nix
  ];
  time.timeZone = "America/Chicago";
  networking.hostName = "andromeda";
  networking.hostId = "10465c4e"; # random, required by zfs
  system.stateVersion = "25.11";
}
