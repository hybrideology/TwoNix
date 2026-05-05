_: {
  flake.nixosModules.systemd = _: {
    vars.persistence = {
      dirs = [
        "/var/lib/systemd"
        "/var/lib/lastlog"
        "/var/log"
        {
          directory = "/var/lib/private";
          mode = "700";
        }
      ];
      files = [
        "/etc/adjtime"
        "/etc/machine-id"
      ];
    };
  };
}
