_: {
  flake.modules.nixos.power = _: {
    services = {
      power-profiles-daemon.enable = true;
      upower.enable = true;
    };
    vars.persistence.dirs = [
      "/var/lib/power-profiles-daemon"
      "/var/lib/upower"
    ];
  };
}
