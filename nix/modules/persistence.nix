_: {
  flake.modules.nixos.persistence = {
    config,
    lib,
    ...
  }: let
    cfg = config.vars.persistence;
    pathOpt = desc:
      lib.mkOption {
        default = [];
        type = lib.types.listOf (lib.types.either lib.types.str lib.types.attrs);
        description = desc;
      };
  in {
    options.vars.persistence = {
      enable = lib.mkEnableOption "impermanence";
      dir = lib.mkOption {
        default = "/nix/persist";
        type = lib.types.str;
        description = "Primary impermanence store directory.";
      };
      laDir = lib.mkOption {
        default = "/nix/persist-la";
        type = lib.types.str;
        description = "Secondary impermanence store directory (low-availability, HDD-backed).";
      };
      dirs = pathOpt "Directories to persist across reboots (primary store).";
      files = pathOpt "Files to persist across reboots (primary store).";
      laDirs = pathOpt "Directories to persist across reboots (low-availability, HDD-backed store).";
      laFiles = pathOpt "Files to persist across reboots (low-availability, HDD-backed store).";
    };
    config = {
      environment.persistence = {
        ${cfg.dir} = {
          inherit (cfg) enable;
          hideMounts = true;
          directories =
            [
              "/var/lib/systemd"
              "/var/lib/lastlog"
              "/var/lib/nixos"
              "/var/log"
              {
                directory = "/var/lib/private";
                mode = "700";
              }
            ]
            ++ lib.optional config.networking.dhcpcd.enable "/var/lib/dhcpcd"
            ++ lib.optional config.security.sudo.enable "/var/db/sudo"
            ++ lib.optional config.security.acme.acceptTerms "/var/lib/acme"
            ++ cfg.dirs;
          files =
            [
              "/etc/adjtime"
              "/etc/machine-id" # nixos expects this
            ]
            ++ lib.optional config.services.logrotate.enable "/var/lib/logrotate.status"
            ++ cfg.files;
        };
        ${cfg.laDir} = {
          inherit (cfg) enable;
          hideMounts = true;
          directories = cfg.laDirs;
          files = cfg.laFiles;
        };
      };
    };
  };
}
