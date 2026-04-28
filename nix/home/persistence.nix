_: {
  flake.homeModules.persistence = {lib, ...}: let
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
  in {
    options.vars.persistence = {
      dirs = lib.mkOption {
        default = [];
        type = lib.types.listOf dirEntry;
        description = "Directories to persist across reboots (primary store).";
      };
      files = lib.mkOption {
        default = [];
        type = lib.types.listOf fileEntry;
        description = "Files to persist across reboots (primary store).";
      };
      laDirs = lib.mkOption {
        default = [];
        type = lib.types.listOf dirEntry;
        description = "Directories to persist across reboots (low-availability, HDD-backed store).";
      };
      laFiles = lib.mkOption {
        default = [];
        type = lib.types.listOf fileEntry;
        description = "Files to persist across reboots (low-availability, HDD-backed store).";
      };
    };
  };
}
