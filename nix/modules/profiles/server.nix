{self, ...}: {
  flake.nixosModules.server = {
    imports = [
      self.nixosModules.base
      self.nixosModules.data-dirs
    ];
  };
}
