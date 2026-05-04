_: {
  flake.nixosModules.persistence = {
    config,
    lib,
    ...
  }: let
    cfg = config.vars.persistence;
    dirEntry = lib.types.either lib.types.str (lib.types.submodule {
      options = {
        directory = lib.mkOption {type = lib.types.str;};
        mode = lib.mkOption {
          type = lib.types.str;
          default = "0755";
        };
        user = lib.mkOption {
          type = lib.types.str;
          default = "root";
        };
        group = lib.mkOption {
          type = lib.types.str;
          default = "root";
        };
      };
    });
    fileEntry = lib.types.either lib.types.str (lib.types.submodule {
      options = {
        file = lib.mkOption {type = lib.types.str;};
        parentDirectory = lib.mkOption {
          type = lib.types.attrs;
          default = {};
        };
      };
    });
    dirOpt = desc:
      lib.mkOption {
        default = [];
        type = lib.types.listOf dirEntry;
        description = desc;
      };
    fileOpt = desc:
      lib.mkOption {
        default = [];
        type = lib.types.listOf fileEntry;
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
      dirs = dirOpt "Directories to persist across reboots (primary store).";
      files = fileOpt "Files to persist across reboots (primary store).";
      laDirs = dirOpt "Directories to persist across reboots (low-availability, HDD-backed store).";
      laFiles = fileOpt "Files to persist across reboots (low-availability, HDD-backed store).";
    };
    config = lib.mkIf cfg.enable {
      environment.persistence =
        {
          ${cfg.dir} = {
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
              ++ cfg.dirs
              ++ lib.optionals (cfg.laDir == cfg.dir) cfg.laDirs;
            files =
              [
                "/etc/adjtime"
                "/etc/machine-id" # nixos expects this
              ]
              ++ cfg.files
              ++ lib.optionals (cfg.laDir == cfg.dir) cfg.laFiles;
          };
        }
        // lib.optionalAttrs (cfg.laDir != cfg.dir) {
          ${cfg.laDir} = {
            hideMounts = true;
            directories = cfg.laDirs;
            files = cfg.laFiles;
          };
        };
    };
  };
}
