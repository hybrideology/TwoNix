_: {
  flake.homeModules.btop = {
    lib,
    osConfig,
    ...
  }: {
    programs.btop = {
      enable = true;
      settings = {
        theme_background = false;
        proc_tree = true;
        disks_filter =
          # exclude persistence bind mounts
          "exclude= "
          + lib.concatStringsSep " " (lib.flatten (lib.mapAttrsToList (store: loc: (lib.map (e: "${store}${e.directory}") loc.directories)) osConfig.environment.persistence));
      };
    };
  };
}
