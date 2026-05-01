_: {
  flake.nixosModules.wireguard-client = {
    config,
    lib,
    ...
  }: {
    options.vars.wireguard = lib.mkOption {
      default = null;
      description = "WireGuard client configuration. Set to null to disable.";
      type = lib.types.nullOr (lib.types.submodule {
        options = {
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

    config = lib.mkIf (config.vars.wireguard != null) {
      sops.secrets.personal_vpn_key = {
        mode = "440";
        owner = config.users.users.systemd-network.name;
        inherit (config.users.users.systemd-network) group;
      };
      networking.useNetworkd = true;
      systemd.network = {
        enable = true;
        networks."50-wg0" = {
          matchConfig.Name = "wg0";
          address = ["${config.vars.wireguard.clientIp}/24"];
          dns = [config.vars.wireguard.dnsIp];
        };
        netdevs."50-wg0" = {
          netdevConfig = {
            Kind = "wireguard";
            Name = "wg0";
          };
          wireguardConfig = {
            PrivateKeyFile = config.sops.secrets.personal_vpn_key.path;
            RouteTable = "main";
          };
          wireguardPeers = [
            {
              PublicKey = config.vars.wireguard.serverPublicKey;
              AllowedIPs = ["10.0.0.0/24"];
              Endpoint = config.vars.wireguard.endpoint;
            }
          ];
        };
      };
    };
  };
}
