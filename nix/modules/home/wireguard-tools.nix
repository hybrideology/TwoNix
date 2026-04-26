_: {
  flake.homeModules.wireguard-tools = {pkgs, ...}: {
    home.packages = [pkgs.wireguard-tools];
  };
}
