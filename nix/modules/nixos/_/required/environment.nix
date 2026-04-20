{inputs, ...}: {
  imports = [inputs.impermanence.nixosModules.impermanence];
  environment.defaultPackages = [];
  security.sudo = {
    wheelNeedsPassword = true;
    execWheelOnly = true;
  };
}
