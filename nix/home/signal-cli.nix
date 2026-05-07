_: {
  flake.homeModules.signal-cli = {pkgs, ...}: {
    home.packages = [pkgs.signal-cli];
    vars.persistence.dirs = [".local/share/signal-cli"];
  };
}
