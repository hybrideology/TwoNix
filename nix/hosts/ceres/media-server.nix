{
  config,
  inputs,
  ...
}: let
  dirs = config.vars.dataDirs;
in {
  sops.secrets.vpn_proxy_conf = {
    sopsFile = inputs.secrets.ceres-vpn-proxy;
    mode = "440";
    format = "binary";
  };
  imports = [inputs.nixarr.nixosModules.default];
  nixarr = {
    enable = true;
    stateDir = dirs.apps;
    mediaDir = dirs.media;
    audiobookshelf = {
      enable = true; # serve audiobooks, podcasts
      openFirewall = false;
    };
    autobrr = {
      enable = true; # auto download manager
      openFirewall = false;
    };
    bazarr = {
      enable = true; # subtitles
      openFirewall = false;
    };
    jellyfin = {
      enable = true; # serve movies, shows, music
      openFirewall = false;
    };
    jellyseerr = {
      enable = true; # requests
      openFirewall = false;
    };
    komga = {
      enable = true; # comics, ebooks
      openFirewall = false;
    };
    transmission = {
      enable = true; # torrent client
      vpn.enable = true;
      peerPort = 15758;
      openFirewall = true; # can't get reverse proxy to work
    };
    vpn = {
      enable = true;
      wgConf = config.sops.secrets.vpn_proxy_conf.path;
    };
  };
  networking.firewall.allowedTCPPorts = [80 443];
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedBrotliSettings = true;
    recommendedOptimisation = true;
    recommendedTlsSettings = true;
    virtualHosts = {
      "audiobookshelf.ceres.vpn".locations."/".proxyPass = "http://127.0.0.1:${toString config.nixarr.audiobookshelf.port}";
      "aurobrr.ceres.vpn".locations."/".proxyPass = "http://127.0.0.1:${toString config.nixarr.autobrr.settings.port}";
      "jellyfin.ceres.vpn".locations."/".proxyPass = "http://127.0.0.1:8096"; # jellyfin port
      "jellyseerr.ceres.vpn".locations."/".proxyPass = "http://127.0.0.1:5055"; # jellyseerr port
    };
  };
}
