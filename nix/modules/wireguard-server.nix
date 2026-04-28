_: {
  flake.modules.nixos.wireguard-server = {
    config,
    lib,
    ...
  }: {
    options.vars.vpn = {
      serverIp = lib.mkOption {
        default = "10.0.0.1";
        type = lib.types.str;
        description = "WireGuard server IP address on the VPN subnet.";
      };
      subnet = lib.mkOption {
        default = "10.0.0.0/24";
        type = lib.types.str;
        description = "WireGuard VPN subnet CIDR.";
      };
      domain = lib.mkOption {
        type = lib.types.str;
        description = "DNS domain for VPN subnet hosts.";
      };
      peers = lib.mkOption {
        default = [];
        type = lib.types.listOf (lib.types.attrsOf lib.types.anything);
        description = "WireGuard peer configurations.";
      };
    };

    config = {
      vars.vpn.domain = lib.mkDefault "${config.networking.hostName}.vpn";
      sops.secrets.personal_vpn_key = {
        mode = "440";
        owner = config.users.users.systemd-network.name;
        inherit (config.users.users.systemd-network) group;
      };
      networking = {
        useNetworkd = true;
        firewall.allowedUDPPorts = [51820];
      };
      systemd.network = {
        enable = true;
        networks."60-wg1" = {
          matchConfig.Name = "wg1";
          address = ["${config.vars.vpn.serverIp}/24"];
        };
        netdevs."60-wg1" = {
          netdevConfig = {
            Kind = "wireguard";
            Name = "wg1";
          };
          wireguardConfig = {
            ListenPort = 51820;
            PrivateKeyFile = config.sops.secrets.personal_vpn_key.path;
            RouteTable = "main";
          };
          wireguardPeers = config.vars.vpn.peers;
        };
      };
    };
  };
}
