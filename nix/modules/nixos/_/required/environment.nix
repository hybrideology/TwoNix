_: {
  environment.defaultPackages = [];
  security.sudo = {
    wheelNeedsPassword = true;
    execWheelOnly = true;
  };
}
