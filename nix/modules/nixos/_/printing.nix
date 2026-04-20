{config, ...}: {
  services = {
    avahi = {
      enable = true;
      nssmdns4 = true; # resolve .local domains
    };
    printing = {
      enable = true;
      cups-pdf.enable = true;
    };
  };
  environment.persistence.${config.vars.persistence.dir}.directories = ["/var/lib/cups"];
}
