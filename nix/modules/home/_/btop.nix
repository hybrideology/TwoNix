{
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
        + lib.concatStringsSep " " (lib.flatten (lib.mapAttrsToList (_: loc: (lib.map (e: e.dirPath) loc.directories)) osConfig.environment.persistence));
    };
  };
}
