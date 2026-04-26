_: {
  flake.homeModules.rnote = {pkgs, ...}: {
    home.packages = [pkgs.rnote];
  };
}
