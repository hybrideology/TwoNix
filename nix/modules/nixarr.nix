{inputs, ...}: {
  flake.nixosModules.nixarr = {config, ...}: {
    imports = [inputs.nixarr.nixosModules.default];
    nixarr.vpn.accessibleFrom = [config.vars.wireguard_server.subnet];
  };
}
