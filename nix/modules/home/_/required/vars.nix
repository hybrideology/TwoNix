{lib, ...}: {
  options.vars = {
    persistence = let
      pathOpt = lib.mkOption {
        default = [];
        type = lib.types.listOf (lib.types.either lib.types.str lib.types.attrs);
      };
    in {
      dirs = pathOpt;
      files = pathOpt;
      laDirs = pathOpt;
      laFiles = pathOpt;
    };
  };
}
