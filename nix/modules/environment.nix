_: {
  flake.modules.nixos.environment = _: {
    environment.defaultPackages = [];
    security.sudo = {
      wheelNeedsPassword = true;
      execWheelOnly = true;
    };
  };
}
