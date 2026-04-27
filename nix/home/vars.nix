_: {
  flake.homeModules.vars = {lib, ...}: {
    options.vars = {
      persistence = let
        pathOpt = desc:
          lib.mkOption {
            default = [];
            type = lib.types.listOf (lib.types.either lib.types.str lib.types.attrs);
            description = desc;
          };
      in {
        dirs = pathOpt "Directories to persist across reboots (primary store).";
        files = pathOpt "Files to persist across reboots (primary store).";
        laDirs = pathOpt "Directories to persist across reboots (low-availability, HDD-backed store).";
        laFiles = pathOpt "Files to persist across reboots (low-availability, HDD-backed store).";
      };
    };
  };
}
