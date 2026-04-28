_: {
  flake.modules.nixos.power = {config, ...}: {
    services = {
      power-profiles-daemon.enable = true;
      upower.enable = true;
    };
    environment.persistence.${config.vars.persistence.dir}.directories = [
      "/var/lib/power-profiles-daemon"
      "/var/lib/upower"
    ];
  };
}
