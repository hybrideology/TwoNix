{inputs, ...}: {
  imports = [
    inputs.self.homeModules.will
    inputs.self.homeModules.desolate
  ];
  home.stateVersion = "25.11";
}
