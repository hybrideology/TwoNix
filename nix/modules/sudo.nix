_: {
  flake.nixosModules.sudo = _: {
    security.sudo.execWheelOnly = true;
    vars.persistence.dirs = ["/var/db/sudo"];
  };
}
