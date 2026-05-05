_: {
  flake.nixosModules.dhcpcd = _: {
    vars.persistence.dirs = ["/var/lib/dhcpcd"];
  };
}
