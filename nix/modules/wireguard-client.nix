_: {
  flake.nixosModules.wireguard-client = {
    config,
    lib,
    ...
  }: {
    options.vars.wireguard_client = lib.mkOption {
      default = null;
      description = "WireGuard client configuration. Set to null to disable.";
      type = lib.types.nullOr (lib.types.submodule {
        options = {
          interfaceName = lib.mkOption {
            default = "personal-vpn";
            type = lib.types.str;
            description = "WireGuard interface name for the personal VPN.";
          };
          clientIp = lib.mkOption {
            type = lib.types.str;
            description = "WireGuard client IP address (e.g. 10.0.0.2)";
          };
          serverPublicKey = lib.mkOption {
            type = lib.types.str;
            description = "WireGuard server public key.";
          };
          endpoint = lib.mkOption {
            type = lib.types.str;
            description = "WireGuard server endpoint (e.g. host:51820).";
          };
          dnsIp = lib.mkOption {
            default = "10.0.0.1";
            type = lib.types.str;
            description = "DNS server IP to use on the VPN interface.";
          };
        };
      });
    };

    config = lib.mkIf (config.vars.wireguard_client != null) {
      vars.openssh.firewallInterfaces = lib.mkDefault [config.vars.wireguard_client.interfaceName];
      networking.networkmanager.unmanaged = [config.vars.wireguard_client.interfaceName];
      sops.secrets.personal_vpn_key = {
        mode = "440";
        owner = config.users.users.systemd-network.name;
        inherit (config.users.users.systemd-network) group;
      };
      networking.useNetworkd = true;
      systemd.network = {
        enable = true;
        networks."50-${config.vars.wireguard_client.interfaceName}" = {
          matchConfig.Name = config.vars.wireguard_client.interfaceName;
          address = ["${config.vars.wireguard_client.clientIp}/24"];
          dns = [config.vars.wireguard_client.dnsIp];
        };
        netdevs."50-${config.vars.wireguard_client.interfaceName}" = {
          netdevConfig = {
            Kind = "wireguard";
            Name = config.vars.wireguard_client.interfaceName;
          };
          wireguardConfig = {
            PrivateKeyFile = config.sops.secrets.personal_vpn_key.path;
            RouteTable = "main";
          };
          wireguardPeers = [
            {
              PublicKey = config.vars.wireguard_client.serverPublicKey;
              AllowedIPs = ["10.0.0.0/24"];
              Endpoint = config.vars.wireguard_client.endpoint;
            }
          ];
        };
      };
    };
  };
}
