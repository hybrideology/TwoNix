{inputs, ...}: {
  home-manager.users.will = {
    imports = [inputs.self.homeModules.desolate];
    home.stateVersion = "25.11";
  };
}
