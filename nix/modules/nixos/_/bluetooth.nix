{config, ...}: {
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  environment.persistence.${config.vars.persistence.dir}.directories = ["/var/lib/bluetooth"];
}
