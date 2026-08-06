_: {
  flake.nixosModules.actual-budget = {config, ...}: {
    services.actual.enable = true;
    services.nginx.virtualHosts."actual.${config.vars.wireguard_server.domain}" = {
      locations."/".proxyPass = "http://localhost:${toString config.services.actual.settings.port}";
      enableACME = true;
      forceSSL = true;
    };
  };
}
