{inputs, ...}: {
  flake.nixosModules.ceres = {config, ...}: let
    dirs = config.vars.dataDirs;
  in {
    imports = [inputs.nixarr.nixosModules.default];
    sops.secrets.vpn_proxy_conf = {
      sopsFile = inputs.secrets.ceres-vpn-proxy;
      mode = "440";
      format = "binary";
      owner = "root";
    };
    nixarr = {
      enable = true;
      stateDir = dirs.apps;
      mediaDir = dirs.media;
      audiobookshelf.enable = true; # serve audiobooks, podcasts
      jellyfin.enable = true; # serve movies, shows, music
      seerr.enable = true; # requests
      bazarr = {
        enable = true; # subtitles
        settings-sync = {
          radarr.enable = true;
          sonarr.enable = true;
        };
      };
      lidarr.enable = true; # music
      radarr = {
        enable = true; # movies
        settings-sync.transmission.enable = true;
      };
      sonarr = {
        enable = true; # shows
        settings-sync.transmission.enable = true;
      };
      prowlarr = {
        enable = true; # index manager
        settings-sync = {
          enable-nixarr-apps = true;
          tags = ["usenet" "torrent" "private"];
        };
      };
      recyclarr = {
        enable = true; # settings manager
        configuration = {
          sonarr = {
            series = {
              base_url = "http://localhost:${toString config.nixarr.sonarr.port}";
              api_key = "!env_var SONARR_API_KEY";
              quality_definition = {
                type = "series";
              };
              delete_old_custom_formats = true;
            };
          };
          radarr = {
            movies = {
              base_url = "http://localhost:${toString config.nixarr.radarr.port}";
              api_key = "!env_var RADARR_API_KEY";
              quality_definition = {
                type = "movie";
              };
              delete_old_custom_formats = true;
            };
          };
        };
      };
      transmission = {
        enable = true; # torrent client
        vpn.enable = true;
        peerPort = 15758;
      };
      vpn = {
        enable = true;
        accessibleFrom = [config.vars.wireguard_server.subnet];
        wgConf = config.sops.secrets.vpn_proxy_conf.path;
        proxyListenAddr = "127.0.0.1";
      };
    };
    services.lidarr.settings.auth.required = "DisabledForLocalAddresses";
    services.radarr.settings.auth.required = "DisabledForLocalAddresses";
    services.sonarr.settings.auth.required = "DisabledForLocalAddresses";
    services.prowlarr.settings.auth.required = "DisabledForLocalAddresses";
    services.jackett = {
      enable = true;
      dataDir = "${config.nixarr.stateDir}/jackett";
    };
    services.flaresolverr.enable = true;
    networking.firewall.interfaces.${config.vars.wireguard_server.interfaceName}.allowedTCPPorts = [80];
    security.acme.acceptTerms = true;
    services.nginx = {
      enable = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      virtualHosts = {
        "audiobookshelf.${config.vars.wireguard_server.domain}" = {
          locations."/".proxyPass = "http://localhost:${toString config.nixarr.audiobookshelf.port}";
          # enableACME = true;
          # forceSSL = true;
        };
        "bazarr.${config.vars.wireguard_server.domain}" = {
          locations."/".proxyPass = "http://localhost:${toString config.nixarr.bazarr.port}";
          # enableACME = true;
          # forceSSL = true;
        };
        "jackett.${config.vars.wireguard_server.domain}" = {
          locations."/".proxyPass = "http://localhost:${toString config.services.jackett.port}";
          # enableACME = true;
          # forceSSL = true;
        };
        "media.${config.vars.wireguard_server.domain}" = {
          locations."/".proxyPass = "http://localhost:${toString config.nixarr.jellyfin.port}";
          # enableACME = true;
          # forceSSL = true;
        };
        "lidarr.${config.vars.wireguard_server.domain}" = {
          locations."/".proxyPass = "http://localhost:${toString config.nixarr.lidarr.port}";
          # enableACME = true;
          # forceSSL = true;
        };
        "prowlarr.${config.vars.wireguard_server.domain}" = {
          locations."/".proxyPass = "http://localhost:${toString config.nixarr.prowlarr.port}";
          # enableACME = true;
          # forceSSL = true;
        };
        "radarr.${config.vars.wireguard_server.domain}" = {
          locations."/".proxyPass = "http://localhost:${toString config.nixarr.radarr.port}";
          # enableACME = true;
          # forceSSL = true;
        };
        "request.${config.vars.wireguard_server.domain}" = {
          locations."/".proxyPass = "http://localhost:${toString config.nixarr.seerr.port}";
          # enableACME = true;
          # forceSSL = true;
        };
        "sonarr.${config.vars.wireguard_server.domain}" = {
          locations."/".proxyPass = "http://localhost:${toString config.nixarr.sonarr.port}";
          # enableACME = true;
          # forceSSL = true;
        };
        "transmission.${config.vars.wireguard_server.domain}" = {
          locations."/" = {
            proxyPass = "http://localhost:${toString config.nixarr.transmission.uiPort}"; #uses vpn address
            proxyWebsockets = true;
          };
          # enableACME = true;
          # forceSSL = true;
        };
      };
    };
  };
}
