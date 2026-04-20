{config, ...}: {
  services.i2pd = {
    enable = true;
    enableIPv6 = true;
    yggdrasil.enable = true;
    proto.sam.enable = true;
  };
  environment.persistence.${config.vars.persistence.dir}.directories = ["/var/lib/i2pd/"];
}
