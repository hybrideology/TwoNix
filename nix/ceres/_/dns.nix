{config, ...}: {
  vars.persistence.dirs = ["/var/lib/dnsmasq"];
  services.dnsmasq = {
    enable = true;
    resolveLocalQueries = false;
    settings = {
      bind-interfaces = true;
      listen-address = config.vars.vpn.serverIp;
      address = [
        "/${config.vars.vpn.domain}/${config.vars.vpn.serverIp}"
        "/*.${config.vars.vpn.domain}/${config.vars.vpn.serverIp}"
      ];
    };
  };
  networking.firewall = {
    allowedUDPPorts = [53];
    allowedTCPPorts = [53];
  };
}
