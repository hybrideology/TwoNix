_: {
  flake.nixosModules.ceres = {config, ...}: {
    vars.persistence.dirs = ["/var/lib/dnsmasq"];
    services.dnsmasq = {
      enable = true;
      resolveLocalQueries = false;
      settings = {
        bind-interfaces = true;
        listen-address = config.vars.wireguard_server.serverIp;
        address = [
          "/${config.vars.wireguard_server.domain}/${config.vars.wireguard_server.serverIp}"
          "/*.${config.vars.wireguard_server.domain}/${config.vars.wireguard_server.serverIp}"
        ];
      };
    };
    networking.firewall.interfaces.${config.vars.wireguard_server.interfaceName} = {
      allowedUDPPorts = [53];
      allowedTCPPorts = [53];
    };
  };
}
