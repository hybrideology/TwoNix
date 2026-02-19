{lib, ...}: {
  options.vars.dataDirs = {
    media = lib.mkOption {
      default = "/srv/media";
      type = lib.types.str;
    };
    archive = lib.mkOption {
      default = "/srv/archive";
      type = lib.types.str;
    };
    db = lib.mkOption {
      default = "/srv/db";
      type = lib.types.str;
    };
    apps = lib.mkOption {
      default = "/srv/apps";
      type = lib.types.str;
    };
  };
}
