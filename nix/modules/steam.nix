_: {
  flake.nixosModules.steam = {pkgs, ...}: {
    vars.unfreePkgs = [
      "steam"
      "steam-original"
      "steam-unwrapped"
      "steam-run"
    ];
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };
    environment.systemPackages = [pkgs.gamescope];
  };
}
