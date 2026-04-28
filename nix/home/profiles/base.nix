{config, ...}: {
  flake.homeModules.base = {
    imports = [
      config.flake.homeModules.vars
      config.flake.homeModules.btop
      config.flake.homeModules.helix
      config.flake.homeModules.jujutsu
      config.flake.homeModules.nh
      config.flake.homeModules.nixos-anywhere
      config.flake.homeModules.ssh
      config.flake.homeModules.starship
      config.flake.homeModules.unar
      config.flake.homeModules.wireguard-tools
      config.flake.homeModules.yazi
      config.flake.homeModules.zsh
    ];
  };
}
