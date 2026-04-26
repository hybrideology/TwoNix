_: {
  flake.homeModules.unar = {pkgs, ...}: {
    home.packages = [
      pkgs.unar
    ];
  };
}
