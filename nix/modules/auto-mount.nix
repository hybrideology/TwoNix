_: {
  flake.nixosModules.auto-mount = _: {
    services.udisks2.enable = true;
  };
}
