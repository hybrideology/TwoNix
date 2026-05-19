_: {
  flake.homeModules.persistence = {lib, ...}: let
    dirEntry = lib.types.either lib.types.str lib.types.attrs;
    fileEntry = lib.types.either lib.types.str lib.types.attrs;
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
