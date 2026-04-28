_: {
  flake.modules.nixos.networkmanager = _: {
    networking.networkmanager = {
      enable = true;
      unmanaged = ["wg0"];
    };

    vars.persistence.dirs = [
      {
        directory = "/etc/NetworkManager/system-connections";
        mode = "0700";
      }
      "/var/lib/NetworkManager"
    ];
  };
}
