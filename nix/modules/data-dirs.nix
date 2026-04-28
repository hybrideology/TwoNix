_: {
  flake.modules.nixos.data-dirs = {lib, ...}: {
    options.vars.dataDirs = {
      media = lib.mkOption {
        default = "/srv/media";
        type = lib.types.str;
        description = "Root directory for media files served by nixarr.";
      };
      archive = lib.mkOption {
        default = "/srv/archive";
        type = lib.types.str;
        description = "Root directory for archival storage (e.g. database backups).";
      };
      db = lib.mkOption {
        default = "/srv/db";
        type = lib.types.str;
        description = "Root directory for persistent database storage.";
      };
      apps = lib.mkOption {
        default = "/srv/apps";
        type = lib.types.str;
        description = "Root directory for application state directories.";
      };
    };
  };
}
