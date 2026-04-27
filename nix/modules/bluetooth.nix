_: {
  flake.modules.nixos.bluetooth = {config, ...}: {
    hardware.bluetooth.enable = true;
    environment.persistence.${config.vars.persistence.dir}.directories = ["/var/lib/bluetooth"];
  };
}
