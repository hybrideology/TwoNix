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
    hmUsers =
      if lib.hasAttr "home-manager" config
      then config.home-manager.users
      else {};
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
      homeDirs = dirOpt "Directories to persist across reboots for each home-manager user (primary store).";
      homeFiles = fileOpt "Files to persist across reboots for each home-manager user (primary store).";
      homeLaDirs = dirOpt "Directories to persist across reboots for each home-manager user (low-availability store).";
      homeLaFiles = fileOpt "Files to persist across reboots for each home-manager user (low-availability store).";
    };
    config = lib.mkIf cfg.enable {
      environment.persistence = lib.mkMerge (
        [
          {
            ${cfg.dir} = {
              hideMounts = true;
              directories = cfg.dirs ++ lib.optionals (cfg.laDir == cfg.dir) cfg.laDirs;
              files = cfg.files ++ lib.optionals (cfg.laDir == cfg.dir) cfg.laFiles;
            };
          }
        ]
        ++ lib.optional (cfg.laDir != cfg.dir) {
          ${cfg.laDir} = {
            hideMounts = true;
            directories = cfg.laDirs;
            files = cfg.laFiles;
          };
        }
        ++ lib.mapAttrsToList (username: hmUserCfg: {
          ${cfg.dir}.users.${username} = {
            files = cfg.homeFiles ++ hmUserCfg.vars.persistence.files;
            directories = cfg.homeDirs ++ hmUserCfg.vars.persistence.dirs;
          };
        })
        hmUsers
        ++ lib.mapAttrsToList (username: hmUserCfg: {
          ${cfg.laDir}.users.${username} = {
            files = cfg.homeLaFiles ++ hmUserCfg.vars.persistence.laFiles;
            directories = cfg.homeLaDirs ++ hmUserCfg.vars.persistence.laDirs;
          };
        })
        hmUsers
      );
    };
  };
}
