_: {
  flake.nixosModules.i2pd = _: {
    services.i2pd = {
      enable = true;
      enableIPv6 = true;
      yggdrasil.enable = true;
      proto.sam.enable = true;
    };
    vars.persistence.dirs = ["/var/lib/i2pd/"];
  };
}
