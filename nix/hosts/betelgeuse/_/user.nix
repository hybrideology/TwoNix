{inputs, ...}: {
  home-manager.users.will = {
    imports = [inputs.self.homeModules.earth];
    home.stateVersion = "25.11";
  };
}
