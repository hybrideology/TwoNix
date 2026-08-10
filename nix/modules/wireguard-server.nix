_: {
  flake.nixosModules.wireguard-server = {
    config,
    lib,
    ...
  }: let
    cfg = config.vars.wireguard_server;
  in {
    options.vars.wireguard_server = {
      interfaceName = lib.mkOption {
        default = "personal-vpn";
        type = lib.types.str;
        description = "WireGuard interface name for the personal VPN.";
      };
      internalIp = lib.mkOption {
        default = "10.0.0.1";
        type = lib.types.str;
        description = "WireGuard server IP address on the VPN subnet.";
      };
      listenPort = lib.mkOption {
        default = 51820;
        type = lib.types.int;
        description = "WireGuard listen port, will be opened on UDP";
      };
      subnet = lib.mkOption {
        default = "10.0.0.0/24";
        type = lib.types.str;
        description = "WireGuard VPN subnet CIDR.";
      };
      domain = lib.mkOption {
        default = "${config.networking.hostName}.vpn";
        type = lib.types.str;
        description = "DNS domain for VPN subnet hosts.";
      };
      peers = lib.mkOption {
        default = [];
        type = lib.types.listOf (lib.types.attrsOf lib.types.anything);
        description = "WireGuard peer configurations.";
      };
    };

    config = let
      subnetMask = builtins.elemAt (builtins.split "/" cfg.subnet) 2;
    in {
      vars.openssh.firewallInterfaces = lib.mkDefault [cfg.interfaceName];
      sops.secrets.personal_vpn_key = {
        mode = "440";
        owner = config.users.users.systemd-network.name;
        group = config.users.users.systemd-network.group;
      };
      networking = {
        useNetworkd = true;
        firewall.allowedUDPPorts = [cfg.listenPort];
      };
      systemd.network = {
        enable = true;
        networks."60-${cfg.interfaceName}" = {
          matchConfig.Name = cfg.interfaceName;
          linkConfig.RequiredForOnline = "no";
          address = ["${cfg.internalIp}/${subnetMask}"];
        };
        netdevs."60-${cfg.interfaceName}" = {
          netdevConfig = {
            Kind = "wireguard";
            Name = cfg.interfaceName;
          };
          wireguardConfig = {
            ListenPort = cfg.listenPort;
            PrivateKeyFile = config.sops.secrets.personal_vpn_key.path;
            RouteTable = "main";
          };
          wireguardPeers = cfg.peers;
        };
      };
      services.dnsmasq = {
        enable = true;
        resolveLocalQueries = false;
        settings = {
          bind-interfaces = true;
          listen-address = cfg.internalIp;
          address = [
            "/${cfg.domain}/${cfg.internalIp}"
            "/*.${cfg.domain}/${cfg.internalIp}"
          ];
        };
      };
      networking.firewall.interfaces.${cfg.interfaceName} = {
        allowedUDPPorts = [53];
        allowedTCPPorts = [53];
      };
      vars.persistence.dirs = ["/var/lib/dnsmasq"];
    };
  };
}
