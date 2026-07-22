{inputs, ...}: {
  flake.nixosModules.ceres = {config, ...}: let
    srvDir = "/srv";
    mediaDir = "${srvDir}/media";
    mediaUser = "media";
    torrentDir = "${srvDir}/torrent";
    torrentNamespace = "torrent";
    torrentPeerPort = 15758;
    moviesDir = "${mediaDir}/movies";
    showsDir = "${mediaDir}/shows";
    musicDir = "${mediaDir}/music";
    podcastsDir = "${mediaDir}/podcasts";
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
      groups.${mediaUser}.members = [
        config.services.lidarr.user
        config.services.radarr.user
        config.services.sonarr.user
        config.services.podgrab.user
        config.services.jellyfin.user
      ];
      groups.${config.services.transmission.group}.members = [
        config.services.lidarr.user
        config.services.radarr.user
        config.services.sonarr.user
      ];
      groups.${config.services.sonarr.group}.members = [
        config.services.bazarr.user
      ];
      groups.${config.services.radarr.group}.members = [
        config.services.bazarr.user
      ];
      groups.${config.services.lidarr.group}.members = [
        config.services.bazarr.user
      ];
    };
    services = {
      # step-ca = {
      #   enable = true;
      #   address = "127.0.0.1";
      #   port = 9531;
      #   # needs settings
      # };
      # Download Managers
      lidarr.enable = true;
      radarr.enable = true;
      sonarr.enable = true;
      bazarr.enable = true;
      podgrab = {
        enable = true;
        dataDirectory = podcastsDir;
        port = 4242;
      };
      # Index Tools
      flaresolverr.enable = true;
      prowlarr.enable = true;
      jackett.enable = true;
      #Download Clients
      transmission = {
        enable = true;
        settings = {
          peer-port = torrentPeerPort;
          download-dir = torrentDir;
          incomplete-dir-enabled = false;
          rpc-bind-address = config.vpnNamespaces.${torrentNamespace}.namespaceAddress;
          rpc-host-whitelist-enabled = false;
          rpc-whitelist-enabled = true;
          rpc-whitelist = config.vpnNamespaces.${torrentNamespace}.bridgeAddress;
        };
      };
      # Servers
      jellyfin.enable = true;
      seerr.enable = true;
      audiobookshelf.enable = true;
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
      {
        directory = config.services.transmission.home;
        user = config.services.transmission.user;
        group = config.services.transmission.group;
      }
      {
        directory = config.services.lidarr.dataDir;
        user = config.services.lidarr.user;
        group = config.services.lidarr.group;
      }
      {
        directory = config.services.radarr.dataDir;
        user = config.services.radarr.user;
        group = config.services.radarr.group;
      }
      {
        directory = config.services.sonarr.dataDir;
        user = config.services.sonarr.user;
        group = config.services.sonarr.group;
      }
      {
        directory = config.services.bazarr.dataDir;
        user = config.services.bazarr.user;
        group = config.services.bazarr.group;
      }
      {
        directory = config.services.jackett.dataDir;
        user = config.services.jackett.user;
        group = config.services.jackett.group;
      }
      {
        directory = config.services.jellyfin.cacheDir;
        user = config.services.jellyfin.user;
        group = config.services.jellyfin.group;
      }
      {
        directory = config.services.jellyfin.configDir;
        user = config.services.jellyfin.user;
        group = config.services.jellyfin.group;
      }
      {
        directory = config.services.jellyfin.dataDir;
        user = config.services.jellyfin.user;
        group = config.services.jellyfin.group;
      }
      {
        directory = config.services.jellyfin.logDir;
        user = config.services.jellyfin.user;
        group = config.services.jellyfin.group;
      }
      {
        directory = "/var/lib/podgrab"; #podgrab module hard-codes this
        user = config.services.podgrab.user;
        group = config.services.podgrab.group;
      }
      {
        directory = "/var/lib/${config.services.audiobookshelf.dataDir}"; #podgrab module hard-codes this
        user = config.services.podgrab.user;
        group = config.services.podgrab.group;
      }
      # do not mount prowlarr, it auto mounts under systemd private
      # do not mount seerr, it auto mounts under systemd private
    ];
    vars.persistence.laDirs = [
      srvDir
    ];
    systemd.tmpfiles.rules = [
      "d ${torrentDir} 0755 ${config.services.transmission.user} ${config.services.transmission.group} -"
      "d ${mediaDir} 0755 ${config.users.users.${mediaUser}.name} ${config.users.users.${mediaUser}.group} -"
      "d ${musicDir} 0775 ${config.users.users.${mediaUser}.name} ${config.users.users.${mediaUser}.group} -"
      "d ${showsDir} 0775 ${config.users.users.${mediaUser}.name} ${config.users.users.${mediaUser}.group} -"
      "d ${moviesDir} 0775 ${config.users.users.${mediaUser}.name} ${config.users.users.${mediaUser}.group} -"
      "d ${podcastsDir} 0775 ${config.users.users.${mediaUser}.name} ${config.users.users.${mediaUser}.group} -"
    ];
    networking.firewall.interfaces.${config.vars.wireguard_server.interfaceName}.allowedTCPPorts = [443];
    security.acme.acceptTerms = true; # note: move this to dns/vpn module
    services.nginx = {
      enable = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;
      virtualHosts = {
        "transmission.${config.vars.wireguard_server.domain}" = {
          locations."/" = {
            proxyPass = "http://${config.vpnNamespaces.${torrentNamespace}.namespaceAddress}:${toString config.services.transmission.settings.rpc-port}"; #uses vpn address
            proxyWebsockets = true;
          };
          enableACME = true;
          forceSSL = true;
        };
        "lidarr.${config.vars.wireguard_server.domain}" = {
          locations."/".proxyPass = "http://localhost:${toString config.services.lidarr.settings.server.port}";
          enableACME = true;
          forceSSL = true;
        };
        "radarr.${config.vars.wireguard_server.domain}" = {
          locations."/".proxyPass = "http://localhost:${toString config.services.radarr.settings.server.port}";
          enableACME = true;
          forceSSL = true;
        };
        "sonarr.${config.vars.wireguard_server.domain}" = {
          locations."/".proxyPass = "http://localhost:${toString config.services.sonarr.settings.server.port}";
          enableACME = true;
          forceSSL = true;
        };
        "prowlarr.${config.vars.wireguard_server.domain}" = {
          locations."/".proxyPass = "http://localhost:${toString config.services.prowlarr.settings.server.port}";
          enableACME = true;
          forceSSL = true;
        };
        "bazarr.${config.vars.wireguard_server.domain}" = {
          locations."/".proxyPass = "http://localhost:${toString config.services.bazarr.listenPort}";
          enableACME = true;
          forceSSL = true;
        };
        "jackett.${config.vars.wireguard_server.domain}" = {
          locations."/".proxyPass = "http://localhost:${toString config.services.jackett.port}";
          enableACME = true;
          forceSSL = true;
        };
        "jellyfin.${config.vars.wireguard_server.domain}" = {
          locations."/" = {
            proxyPass = "http://localhost:8096";
            proxyWebsockets = true;
          };
          enableACME = true;
          forceSSL = true;
        };
        "seerr.${config.vars.wireguard_server.domain}" = {
          locations."/".proxyPass = "http://localhost:${toString config.services.seerr.port}";
          enableACME = true;
          forceSSL = true;
        };
        "audiobookshelf.${config.vars.wireguard_server.domain}" = {
          locations."/".proxyPass = "http://localhost:${toString config.services.audiobookshelf.port}";
          enableACME = true;
          forceSSL = true;
        };
        "podgrab.${config.vars.wireguard_server.domain}" = {
          locations."/".proxyPass = "http://localhost:${toString config.services.podgrab.port}";
          enableACME = true;
          forceSSL = true;
        };
      };
    };
  };
}
