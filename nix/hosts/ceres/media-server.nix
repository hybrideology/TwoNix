{inputs, ...}: {
  flake.nixosModules.ceres = {config, ...}: let
    mediaDir = "/srv/media";
    mediaUser = "media";
    torrentNamespace = "torrent";
  in {
    imports = [inputs.vpn-confinement.nixosModules.default];
    sops.secrets.vpn_proxy_conf = {
      sopsFile = inputs.secrets.ceres-vpn-proxy;
      mode = "440";
      format = "binary";
      owner = "root";
    };
    users = {
      users.${mediaUser} = {
        isSystemUser = true;
        group = mediaUser;
      };
      groups.${mediaUser} = {
        members = [
          config.services.lidarr.user
          config.services.radarr.user
          config.services.sonarr.user
          config.services.prowlarr.user
        ];
      };
    };
    services = {
      lidarr.enable = true;
      radarr.enable = true;
      sonarr.enable = true;
      prowlarr.enable = true;
      transmission = {
        enable = true;
        settings = {
          peer-port = 15758;
          rpc-bind-address = config.vpnNamespaces.${torrentNamespace}.namespaceAddress;
          rpc-host-whitelist-enabled = false;
          rpc-whitelist-enabled = true;
          rpc-whitelist = config.vpnNamespaces.${torrentNamespace}.bridgeAddress;
        };
      };
    };
    systemd.services.transmission.vpnConfinement = {
      enable = true;
      vpnNamespace = torrentNamespace;
    };
    vpnNamespaces.${torrentNamespace} = {
      enable = true;
      wireguardConfigFile = config.sops.secrets.vpn_proxy_conf.path;
      accessibleFrom = [
        "127.0.0.0/8"
        "::1/128"
      ];
      portMappings = [
        {
          from = config.services.transmission.settings.rpc-port;
          to = config.services.transmission.settings.rpc-port;
          protocol = "tcp";
        }
      ];
      openVPNPorts = [
        {
          port = config.services.transmission.settings.peer-port;
          protocol = "both";
        }
      ];
    };
    vars.persistence.dirs = [
      config.services.lidarr.dataDir
      config.services.radarr.dataDir
      config.services.sonarr.dataDir
      # do not mount prowlarr, it auto mounts under systemd private
    ];
    vars.persistence.laDirs = [
      {
        directory = mediaDir;
        user = config.users.users.${mediaUser}.name;
        group = config.users.users.${mediaUser}.group;
      }
      config.services.transmission.home
      config.services.transmission.settings.download-dir
      config.services.transmission.settings.incomplete-dir
    ];
    systemd.tmpfiles.rules = [
      "d ${mediaDir}/music 0770 ${config.users.users.${mediaUser}.name} ${config.users.users.${mediaUser}.group} -"
      "d ${mediaDir}/shows 0770 ${config.users.users.${mediaUser}.name} ${config.users.users.${mediaUser}.group} -"
      "d ${mediaDir}/movies 0770 ${config.users.users.${mediaUser}.name} ${config.users.users.${mediaUser}.group} -"
    ];
    networking.firewall.interfaces.${config.vars.wireguard_server.interfaceName}.allowedTCPPorts = [80];
    services.nginx = {
      enable = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;
      virtualHosts = {
        "lidarr.${config.vars.wireguard_server.domain}" = {
          locations."/".proxyPass = "http://localhost:${toString config.services.lidarr.settings.server.port}";
          # enableACME = true;
          # forceSSL = true;
        };
        "radarr.${config.vars.wireguard_server.domain}" = {
          locations."/".proxyPass = "http://localhost:${toString config.services.radarr.settings.server.port}";
          # enableACME = true;
          # forceSSL = true;
        };
        "sonarr.${config.vars.wireguard_server.domain}" = {
          locations."/".proxyPass = "http://localhost:${toString config.services.sonarr.settings.server.port}";
          # enableACME = true;
          # forceSSL = true;
        };
        "prowlarr.${config.vars.wireguard_server.domain}" = {
          locations."/".proxyPass = "http://localhost:${toString config.services.prowlarr.settings.server.port}";
          # enableACME = true;
          # forceSSL = true;
        };
        "transmission.${config.vars.wireguard_server.domain}" = {
          locations."/" = {
            proxyPass = "http://${config.vpnNamespaces.${torrentNamespace}.namespaceAddress}:${toString config.services.transmission.settings.rpc-port}"; #uses vpn address
            proxyWebsockets = true;
          };
          # enableACME = true;
          # forceSSL = true;
        };
      };
    };
  };
}
