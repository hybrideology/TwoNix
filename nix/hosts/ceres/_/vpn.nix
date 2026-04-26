{
  config,
  ...
}: {
  sops.secrets.personal_vpn_key = {
    mode = "440";
    owner = config.users.users.systemd-network.name;
    inherit (config.users.users.systemd-network) group;
  };
  nixarr.vpn.accessibleFrom = ["10.0.0.0/24"];
  environment.persistence.${config.vars.persistence.dir}.directories = ["/var/lib/dnsmasq"];
  services = {
    nginx.defaultListenAddresses = ["10.0.0.1"];
    dnsmasq = {
      enable = true;
      resolveLocalQueries = false;
      settings = {
        bind-interfaces = true;
        listen-address = "10.0.0.1";
        address = [
          "/ceres.vpn/10.0.0.1"
          "/*.ceres.vpn/10.0.0.1"
        ];
      };
    };
  };
  networking = {
    useNetworkd = true;
    firewall = {
      allowedUDPPorts = [53 51820];
      allowedTCPPorts = [53];
    };
  };
  systemd.network = {
    enable = true;
    networks = {
      "60-wg1" = {
        matchConfig.Name = "wg1";
        address = ["10.0.0.1/24"];
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
            AllowedIPs = [
              "10.0.0.2/32"
            ];
          }
          # sam desktop
          {
            PublicKey = "Bu8uY1wrJVfWEOf7kGuyBYfVA5d1H91FZmEF8gvlCxY=";
            AllowedIPs = [
              "10.0.0.3/32"
            ];
          }
          # graphene
          {
            PublicKey = "g3k/Jr9xGBA5/biBHfpuibWcnksyoYYtVdY/MamXcB4=";
            AllowedIPs = [
              "10.0.0.4/32"
            ];
          }
          # betelgeuse
          {
            PublicKey = "aVeaKlXy5YAootyBmWr0SnZVShrWFcDjQaNKQV//JCI=";
            AllowedIPs = [
              "10.0.0.5/32"
            ];
          }
        ];
      };
    };
  };
}
