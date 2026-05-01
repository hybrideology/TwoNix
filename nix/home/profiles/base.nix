{self, ...}: {
  flake.homeModules.base = {
    imports = [
      self.homeModules.persistence
      self.homeModules.btop
      self.homeModules.helix
      self.homeModules.jujutsu
      self.homeModules.nh
      self.homeModules.nixos-anywhere
      self.homeModules.sops
      self.homeModules.ssh
      self.homeModules.starship
      self.homeModules.unar
      self.homeModules.wireguard-tools
      self.homeModules.yazi
      self.homeModules.zsh
    ];
  };
}
