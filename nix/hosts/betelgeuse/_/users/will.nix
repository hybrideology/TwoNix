{inputs, ...}: {
  imports = [
    inputs.self.homeModules.will
    inputs.self.homeModules.earth
  ];
  home.stateVersion = "25.11";
}
