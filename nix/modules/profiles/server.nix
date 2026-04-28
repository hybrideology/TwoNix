{config, ...}: {
  flake.modules.nixos.server = {
    imports = [
      config.flake.modules.nixos.base
      config.flake.modules.nixos.data-dirs
    ];
  };
}
