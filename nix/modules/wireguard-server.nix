_: {
  flake.nixosModules.wireguard-server = {
    config,
    lib,
    ...
  }: {
    options.vars.wireguard_server = {
      interfaceName = lib.mkOption {
        default = "personal-vpn";
        type = lib.types.str;
        description = "WireGuard interface name for the personal VPN.";
      };
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
      vars.wireguard_server.domain = lib.mkDefault "${config.networking.hostName}.vpn";
      vars.openssh.firewallInterfaces = lib.mkDefault [config.vars.wireguard_server.interfaceName];
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
        networks."60-${config.vars.wireguard_server.interfaceName}" = {
          matchConfig.Name = config.vars.wireguard_server.interfaceName;
          address = ["${config.vars.wireguard_server.serverIp}/24"];
        };
        netdevs."60-${config.vars.wireguard_server.interfaceName}" = {
          netdevConfig = {
            Kind = "wireguard";
            Name = config.vars.wireguard_server.interfaceName;
          };
          wireguardConfig = {
            ListenPort = 51820;
            PrivateKeyFile = config.sops.secrets.personal_vpn_key.path;
            RouteTable = "main";
          };
          wireguardPeers = config.vars.wireguard_server.peers;
        };
      };
    };
  };
}
