_: {
  flake.homeModules.nixos-anywhere = {pkgs, ...}: {
    home.packages = [
      pkgs.nixos-anywhere
    ];
  };
}
