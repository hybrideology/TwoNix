{
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations.ceres = inputs.nixpkgs-small.lib.nixosSystem {
    modules = [
      self.nixosModules.ceres
      self.nixosModules.server
      self.nixosModules.wireguard-server
      self.nixosModules.i2pd
      self.nixosModules.will
      self.nixosModules.nixarr
    ];
  };
  flake.nixosModules.ceres = _: {
    nixpkgs.hostPlatform = "x86_64-linux";
    time.timeZone = "America/Chicago";
    networking.hostName = "ceres";
    networking.hostId = "e0fdcfa7"; # random, required by zfs
    system.stateVersion = "25.11";

    # Hardware
    imports = [inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate];
    hardware.facter.reportPath = ./facter.json;

    # Users
    home-manager.users.will = {
      imports = [self.homeModules.base];
      home.stateVersion = "25.11";
    };

    # VPN
    sops.secrets.personal_vpn_key.sopsFile = inputs.secrets.ceres;
    vars.vpn.peers = [
      # andromeda
      {
        PublicKey = "7ZLGJ8bowq9sDPkNYBXFfQKEoVbFdMAkqW7xQqYwJXM=";
        AllowedIPs = ["10.0.0.2/32"];
      }
      # sam desktop
      {
        PublicKey = "Bu8uY1wrJVfWEOf7kGuyBYfVA5d1H91FZmEF8gvlCxY=";
        AllowedIPs = ["10.0.0.3/32"];
      }
      # betelgeuse
      {
        PublicKey = "aVeaKlXy5YAootyBmWr0SnZVShrWFcDjQaNKQV//JCI=";
        AllowedIPs = ["10.0.0.5/32"];
      }
    ];
  };
}
