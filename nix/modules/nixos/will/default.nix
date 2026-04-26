{config, ...}: {
  flake.modules.nixos.will = {
    imports = [../_/will];
    home-manager.users.will.imports = [config.flake.homeModules.will];
  };
}
