_: {
  flake.modules.nixos.andromeda = {
    nixpkgs.hostPlatform = "x86_64-linux";
    time.timeZone = "America/Chicago";
    networking.hostName = "andromeda";
    networking.hostId = "10465c4e"; # random, required by zfs
    system.stateVersion = "25.11";
  };
}
