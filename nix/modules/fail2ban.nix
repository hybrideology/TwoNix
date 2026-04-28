_: {
  flake.modules.nixos.fail2ban = _: {
    services.fail2ban.enable = true;
    vars.persistence.dirs = [
      {
        directory = "/var/lib/fail2ban";
        mode = "0700";
      }
    ];
  };
}
