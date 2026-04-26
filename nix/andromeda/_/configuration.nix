{...}: {
  imports = [
    ./disko.nix
    ./hardware.nix
  ];
  time.timeZone = "America/Chicago";
  networking.hostName = "andromeda";
  networking.hostId = "10465c4e"; # random, required by zfs
  system.stateVersion = "25.11";
  vars.wireguard.clientIp = "10.0.0.2";
}
