{flake, ...}: {
  imports = [
    flake.nixosModules.server
    ./disko.nix
    ./hardware.nix
    ./users.nix
    # ./vpn.nix
  ];
  time.timeZone = "America/Chicago";
  networking.hostName = "ceres";
  networking.hostId = "e0fdcfa7"; # random, required by zfs
  system.stateVersion = "25.11";
  services.tailscale.enable = true;
}
