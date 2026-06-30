{self, ...}: {
  flake.nixosModules.server = {
    imports = [
      self.nixosModules.base
    ];
  };
}
