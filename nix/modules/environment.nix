_: {
  flake.modules.nixos.environment = _: {
    environment.defaultPackages = [];
    security.sudo.execWheelOnly = true;
  };
}
