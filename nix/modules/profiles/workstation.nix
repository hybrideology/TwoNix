{self, ...}: {
  flake.nixosModules.workstation = {
    imports = [
      self.nixosModules.base
      self.nixosModules.bluetooth
      self.nixosModules.hyprland
      self.nixosModules.power
      self.nixosModules.pipewire
      self.nixosModules.printing
      self.nixosModules.steam
      self.nixosModules.wireguard-client
      self.nixosModules.networkmanager
    ];
  };
}
