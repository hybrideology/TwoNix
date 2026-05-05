{self, ...}: {
  flake.nixosModules.base = {
    imports = [
      self.nixosModules.bash
      self.nixosModules.home-manager
      self.nixosModules.sops
      self.nixosModules.impermanence
      self.nixosModules.disko
      self.nixosModules.environment
      self.nixosModules.groups
      self.nixosModules.nix
      self.nixosModules.nixpkgs
      self.nixosModules.auto-upgrade
      self.nixosModules.clean-store
      self.nixosModules.fail2ban
      self.nixosModules.openssh
      self.nixosModules.persistence
      self.nixosModules.snowflake
      self.nixosModules.sudo
      self.nixosModules.systemd
      self.nixosModules.systemd-boot
    ];
  };
}
