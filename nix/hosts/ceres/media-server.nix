{inputs, ...}: {
  flake.nixosModules.ceres = {config, ...}: let
    mediaDir = "/srv/media";
    transmissionAddress = "192.168.15.1";
  in {
    sops.secrets.vpn_proxy_conf = {
      sopsFile = inputs.secrets.ceres-vpn-proxy;
      mode = "440";
      format = "binary";
      owner = "root";
    };
    users = {
      users.media = {
        isSystemUser = true;
        group = config.users.groups.media.name;
      };
      groups.media = {};
    };
    services = {
      lidarr.enable = true;
      radarr.enable = true;
      sonarr.enable = true;
      prowlarr.enable = true;
    };
    containers.transmission = {
      autoStart = true;
      privateNetwork = true;
      enableTun = true;
      ephemeral = true;
      hostAddress = transmissionAddress;
      bindMounts = {
        ${config.sops.secrets.vpn_proxy_conf.path}.hostPath = config.sops.secrets.vpn_proxy_conf.path;
        ${config.containers.transmission.config.services.transmission.settings.download-dir} = {
          hostPath = config.containers.transmission.config.services.transmission.settings.download-dir;
          isReadOnly = false;
        };
      };
      forwardPorts = [
        {
          containerPort = config.containers.transmission.config.services.transmission.settings.rpc-port;
          hostPort = config.containers.transmission.config.services.transmission.settings.rpc-port;
          protocol = "tcp";
        }
      ];
      config = _: {
        networking = {
          wg-quick.interfaces.wg0.configFile = config.sops.secrets.vpn_proxy_conf.path;
        };
        services.transmission = {
          enable = true;
          settings = {
            rpc-bind-address = "0.0.0.0";
            peer-port = 15758;
            incomplete-dir-enabled = false;
          };
        };
        system.stateVersion = config.system.stateVersion;
      };
    };
    vars.persistence.dirs = [
      config.services.lidarr.dataDir
      config.services.radarr.dataDir
      config.services.sonarr.dataDir
      # do not mount prowlarr, it auto mounts under systemd private
    ];
    vars.persistence.laDirs = [
      mediaDir
      config.containers.transmission.config.services.transmission.settings.download-dir
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
          locations."/".proxyPass = "http://${transmissionAddress}:${toString config.containers.transmission.config.services.transmission.settings.rpc-port}"; #uses vpn address
          # enableACME = true;
          # forceSSL = true;
        };
      };
    };
  };
}
