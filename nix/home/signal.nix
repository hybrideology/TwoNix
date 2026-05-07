_: {
  flake.homeModules.signal = {pkgs, ...}: {
    home.packages = [pkgs.signal-desktop];
  };
}
