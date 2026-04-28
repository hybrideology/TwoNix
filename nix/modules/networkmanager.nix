_: {
  flake.modules.nixos.networkmanager = _: {
    networking.networkmanager = {
      enable = true;
      unmanaged = ["wg0"];
    };

    vars.persistence.dirs = [
      "/etc/NetworkManager/system-connections"
      "/var/lib/NetworkManager"
    ];
  };
}
