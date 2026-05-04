{
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations.andromeda = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.andromeda
      self.nixosModules.workstation
      self.nixosModules.will
      self.nixosModules.nvidia
    ];
  };
  flake.nixosModules.andromeda = _: {
    nixpkgs.hostPlatform = "x86_64-linux";
    time.timeZone = "America/Chicago";
    networking.hostName = "andromeda";
    networking.hostId = "10465c4e"; # random, required by zfs

    # Hardware
    imports = [inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate];
    services.xserver.videoDrivers = [
      "amdgpu"
    ];
    hardware = {
      facter.reportPath = ./facter.json;
      nvidia = {
        prime = {
          offload = {
            enable = true;
            enableOffloadCmd = true;
          };
          reverseSync.enable = true;
          amdgpuBusId = "PCI:15@0:0:0";
          nvidiaBusId = "PCI:1@0:0:0";
        };
      };
    };

    # Users
    home-manager.users.will = {
      imports = [self.homeModules.earth];
      home.stateVersion = "26.05";
      vars.hyprland = {
        monitors = [
          "DP-4, 2560x1440@180, 0x0, 1, bitdepth, 10"
          "DP-5, 2560x1440@180, 2560x0, 1, bitdepth, 10"
          "HDMI-A-2, 1920x1080@144, 1600x-1080, 1"
        ];
        workspaces = [
          "1, default:true, monitor:DP-4"
          "2, default:true, monitor:HDMI-A-2"
          "3, default:true, monitor:DP-5"
        ];
      };
    };

    # VPN
    sops.secrets.personal_vpn_key.sopsFile = inputs.secrets.andromeda;
    system.stateVersion = "26.11";
    vars.wireguard_client = {
      clientIp = "10.0.0.2";
      serverPublicKey = "QWwLEg0SjMm0ZNyb8iPa9V/29/VnHLKt9ZpVUaiE7j0=";
      endpoint = "465241395.xyz:51820";
    };
  };
}
