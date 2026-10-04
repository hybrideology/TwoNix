{self, ...}: {
  flake.homeModules.base = {
    imports = [
      self.homeModules.persistence
      self.homeModules.jujutsu
      self.homeModules.nh
      self.homeModules.nixos-anywhere
      self.homeModules.rsync
      self.homeModules.sops
      self.homeModules.ssh
      self.homeModules.unar
      self.homeModules.wireguard-tools
    ];
  };
}
