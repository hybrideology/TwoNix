_: {
  flake.modules.nixos.ceres = {
    nixpkgs.hostPlatform = "x86_64-linux";
    time.timeZone = "America/Chicago";
    networking.hostName = "ceres";
    networking.hostId = "e0fdcfa7"; # random, required by zfs
    system.stateVersion = "25.11";
  };
}
