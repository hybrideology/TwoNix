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

  flake.nixosModules.betelgeuse = _: {
    nixpkgs.hostPlatform = "x86_64-linux";
    time.timeZone = "America/Chicago";
    networking.hostName = "betelgeuse";
    networking.hostId = "1352f34a"; # random, required by zfs
    system.stateVersion = "25.11";

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
      home.stateVersion = "25.11";
    };

    # VPN
    sops.secrets.personal_vpn_key.sopsFile = inputs.secrets.betelgeuse;
    vars.wireguard = {
      clientIp = "10.0.0.5";
      serverPublicKey = "QWwLEg0SjMm0ZNyb8iPa9V/29/VnHLKt9ZpVUaiE7j0=";
      endpoint = "465241395.xyz:51820";
    };
  };
}
