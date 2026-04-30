_: {
  flake.modules.nixos.ceres = {
    inputs,
    config,
    ...
  }: {
    sops.secrets.personal_vpn_key.sopsFile = inputs.secrets.ceres;
    nixarr.vpn.accessibleFrom = [config.vars.vpn.subnet];
    services.nginx.defaultListenAddresses = [config.vars.vpn.serverIp];
    vars.vpn.peers = [
      # andromeda
      {
        PublicKey = "7ZLGJ8bowq9sDPkNYBXFfQKEoVbFdMAkqW7xQqYwJXM=";
        AllowedIPs = ["10.0.0.2/32"];
      }
      # sam desktop
      {
        PublicKey = "Bu8uY1wrJVfWEOf7kGuyBYfVA5d1H91FZmEF8gvlCxY=";
        AllowedIPs = ["10.0.0.3/32"];
      }
      # betelgeuse
      {
        PublicKey = "aVeaKlXy5YAootyBmWr0SnZVShrWFcDjQaNKQV//JCI=";
        AllowedIPs = ["10.0.0.5/32"];
      }
    ];
  };
}
