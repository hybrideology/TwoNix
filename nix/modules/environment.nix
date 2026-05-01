_: {
  flake.nixosModules.environment = _: {
    environment.defaultPackages = [];
    security.sudo.execWheelOnly = true;
  };
}
