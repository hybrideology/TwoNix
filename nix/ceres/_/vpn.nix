{
  inputs,
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
      default = "ceres.vpn";
      type = lib.types.str;
      description = "DNS domain for VPN subnet hosts.";
    };
  };
  config = {
    sops.secrets.personal_vpn_key = {
      sopsFile = inputs.secrets.ceres;
      mode = "440";
      owner = config.users.users.systemd-network.name;
      inherit (config.users.users.systemd-network) group;
    };
    nixarr.vpn.accessibleFrom = [config.vars.vpn.subnet];
    services.nginx.defaultListenAddresses = [config.vars.vpn.serverIp];
    networking = {
      useNetworkd = true;
      firewall.allowedUDPPorts = [51820];
    };
    systemd.network = {
      enable = true;
      networks = {
        "60-wg1" = {
          matchConfig.Name = "wg1";
          address = ["${config.vars.vpn.serverIp}/24"];
        };
      };
      netdevs = {
        "60-wg1" = {
          netdevConfig = {
            Kind = "wireguard";
            Name = "wg1";
          };
          wireguardConfig = {
            ListenPort = 51820;
            PrivateKeyFile = config.sops.secrets.personal_vpn_key.path;
            RouteTable = "main";
          };
          wireguardPeers = [
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
      };
    };
  };
}
