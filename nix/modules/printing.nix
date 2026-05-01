_: {
  flake.nixosModules.printing = _: {
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
    vars.persistence.dirs = ["/var/lib/cups"];
  };
}
