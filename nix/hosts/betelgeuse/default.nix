{
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations.betelgeuse = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.betelgeuse
      self.nixosModules.workstation
      self.nixosModules.will
      self.nixosModules.nvidia
    ];
  };

  flake.nixosModules.betelgeuse = {config, ...}: {
    nixpkgs.hostPlatform = "x86_64-linux";
    time.timeZone = "America/Chicago";
    networking.hostName = "betelgeuse";
    networking.hostId = "1352f34a"; # random, required by zfs
    system.stateVersion = "26.11";

    sops.secrets = {
      personal_vpn_key = {
        sopsFile = inputs.secrets.betelgeuse;
        mode = "440";
        owner = config.users.users.systemd-network.name;
        group = config.users.users.systemd-network.group;
      };
      update_ssh_key = {
        owner = "root";
        group = "root";
        mode = "0400";
      };
    };

    # Hardware
    imports = [inputs.nixos-hardware.nixosModules.common-gpu-intel];
    services.xserver.videoDrivers = [
      "modesetting"
    ];
    hardware = {
      facter.reportPath = ./facter.json;
      nvidia = {
        prime = {
          offload = {
            enable = true;
            enableOffloadCmd = true;
          };
          intelBusId = "PCI:0@0:2:0";
          nvidiaBusId = "PCI:1@0:0:0";
        };
      };
    };

    # Users
    home-manager.users.will = {
      imports = [self.homeModules.earth];
      home.stateVersion = "26.05";
    };

    # VPN
    vars = {
      auto-upgrade.sshKeyPath = config.sops.secrets.update_ssh_key.path;
      wireguard_client = {
        clientIp = "10.0.0.5";
        serverPublicKey = "QWwLEg0SjMm0ZNyb8iPa9V/29/VnHLKt9ZpVUaiE7j0=";
        privateKeyFile = config.sops.secrets.personal_vpn_key.path;
        endpoint = "465241395.xyz:51820";
      };
    };
  };
}
