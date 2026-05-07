_: {
  flake.homeModules.signal = {pkgs, ...}: {
    home.packages = [pkgs.signal-desktop];
    vars.persistence.dirs = [".config/Signal"];
  };
}
