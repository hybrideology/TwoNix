_: {
  flake.modules.nixos.persistence = {
    config,
    lib,
    ...
  }: let
    cfg = config.vars.persistence;
  in {
    config = {
      environment.persistence = {
        ${cfg.dir} = {
          inherit (cfg) enable;
          hideMounts = true;
          directories =
            [
              "/var/lib/systemd"
              "/var/lib/nixos"
              "/var/log"
              {
                directory = "/var/lib/private";
                mode = "700";
              }
            ]
            ++ lib.optional config.networking.dhcpcd.enable "/var/lib/dhcpcd"
            ++ lib.optional config.security.sudo.enable "/var/db/sudo"
            ++ lib.optional config.security.acme.acceptTerms "/var/lib/acme";
          files = [
            "/etc/adjtime"
            "/etc/machine-id" # nixos expects this
          ];
        };
        ${cfg.laDir} = {
          inherit (cfg) enable;
          hideMounts = true;
        };
      };
    };
  };
}
