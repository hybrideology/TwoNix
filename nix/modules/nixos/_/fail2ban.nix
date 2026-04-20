{config, ...}: {
  services.fail2ban.enable = true;
  environment.persistence.${config.vars.persistence.dir}.directories = [
    {
      directory = "/var/lib/fail2ban";
      mode = "0700";
    }
  ];
}
