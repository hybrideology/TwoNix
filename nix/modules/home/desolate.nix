{config, ...}: {
  flake.homeModules.desolate = {
    imports = [
      config.flake.homeModules.vars
      config.flake.homeModules.btop
      config.flake.homeModules.helix
      config.flake.homeModules.nh
      config.flake.homeModules.ssh
      config.flake.homeModules.unar
      config.flake.homeModules.yazi
    ];
  };
}
