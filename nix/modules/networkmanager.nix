_: {
  flake.nixosModules.networkmanager = _: {
    networking.networkmanager.enable = true;

    vars.persistence.dirs = [
      {
        directory = "/etc/NetworkManager/system-connections";
        mode = "0700";
      }
      "/var/lib/NetworkManager"
    ];
  };
}
