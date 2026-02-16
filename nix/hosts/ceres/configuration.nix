{flake, ...}: {
  imports = [
    flake.nixosModules.server
    ./disko.nix
    ./hardware.nix
    ./matrix-server.nix
    ./secrets.nix
    ./users.nix
    ./vpn.nix
  ];
  time.timeZone = "America/Chicago";
  networking.hostName = "ceres";
  networking.hostId = "e0fdcfa7"; # random, required by zfs
  system.stateVersion = "25.11";
  vars.fqdn = "ceres.vpn";
}
