_: {
  flake.nixosModules.bluetooth = _: {
    hardware.bluetooth.enable = true;
    vars.persistence.dirs = ["/var/lib/bluetooth"];
  };
}
