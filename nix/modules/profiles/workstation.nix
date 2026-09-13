{self, ...}: {
  flake.nixosModules.workstation = {
    imports = [
      self.nixosModules.auto-mount
      self.nixosModules.base
      self.nixosModules.bluetooth
      self.nixosModules.niri
      self.nixosModules.power
      self.nixosModules.pipewire
      self.nixosModules.printing
      self.nixosModules.steam
      self.nixosModules.wireguard-client
      self.nixosModules.networkmanager
    ];
  };
}
