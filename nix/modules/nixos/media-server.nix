{
  config,
  inputs,
  ...
}: let
  dirs = config.vars.dataDirs;
  inherit (config.vars) fqdn;
in {
  assertions = [
    {
      assertion = fqdn != "";
      message = "The FQDN needs to be assigned in order to enable the media server.";
    }
  ];
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
    };
  };
  networking.firewall.allowedTCPPorts = [80 443];
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedBrotliSettings = true;
    virtualHosts = {
      "audiobookshelf.${fqdn}".locations."/".proxyPass = "http://127.0.0.1:${toString config.nixarr.audiobookshelf.port}";
      "aurobrr.${fqdn}".locations."/".proxyPass = "http://127.0.0.1:${toString config.nixarr.autobrr.settings.port}";
      "jellyfin.${fqdn}".locations."/".proxyPass = "http://127.0.0.1:8096"; # jellyfin port
      "jellyseerr.${fqdn}".locations."/".proxyPass = "http://127.0.0.1:5055"; # jellyseerr port
      "transmission.${fqdn}".locations."/".proxyPass = "http://127.0.0.1:${toString config.nixarr.transmission.uiPort}";
    };
  };
}
