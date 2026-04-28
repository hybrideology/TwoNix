{config, ...}: {
  flake.homeModules.desolate = {
    imports = [config.flake.homeModules.base];
  };
}
