_: {
  flake.homeModules.rsync = {pkgs, ...}: {
    home.packages = [pkgs.rsync];
  };
}
