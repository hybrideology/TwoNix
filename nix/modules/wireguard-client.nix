_: {
  flake.nixosModules.wireguard-client = {
    config,
    lib,
    ...
  }: let
    cfg = config.vars.wireguard_client;
  in {
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
          privateKeyFile = lib.mkOption {
            type = lib.types.str;
            description = "Path to private key file.";
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

    config = lib.mkIf (cfg != null) {
      vars.openssh.firewallInterfaces = lib.mkDefault [cfg.interfaceName];
      networking.networkmanager.unmanaged = [cfg.interfaceName];
      networking.useNetworkd = true;
      systemd.network = {
        enable = true;
        networks."50-${cfg.interfaceName}" = {
          matchConfig.Name = cfg.interfaceName;
          address = ["${cfg.clientIp}/24"];
          dns = [cfg.dnsIp];
        };
        netdevs."50-${cfg.interfaceName}" = {
          netdevConfig = {
            Kind = "wireguard";
            Name = cfg.interfaceName;
          };
          wireguardConfig = {
            PrivateKeyFile = cfg.privateKeyFile;
            RouteTable = "main";
          };
          wireguardPeers = [
            {
              PublicKey = cfg.serverPublicKey;
              AllowedIPs = ["10.0.0.0/24"];
              Endpoint = cfg.endpoint;
            }
          ];
        };
      };
    };
  };
}
