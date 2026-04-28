{inputs, ...}: {
  home-manager.users.will = {
    imports = [inputs.self.homeModules.base];
    home.stateVersion = "25.11";
  };
}
