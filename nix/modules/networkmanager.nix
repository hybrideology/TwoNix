_: {
  flake.modules.nixos.networkmanager = {config, ...}: {
    networking.networkmanager = {
      enable = true;
      unmanaged = ["wg0"];
    };

    environment.persistence.${config.vars.persistence.dir}.directories = [
      "/etc/NetworkManager/system-connections"
      "/var/lib/NetworkManager"
    ];
  };
}
