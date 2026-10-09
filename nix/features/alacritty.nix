{
  inputs,
  self,
  ...
}: {
  flake.nixosModules.alacritty = {pkgs, ...}: {
    environment.systemPackages = [self.packages.${pkgs.stdenv.hostPlatform.system}.alacritty];
  };
  perSystem = {
    pkgs,
    self',
    lib,
    ...
  }: {
    packages.alacritty = inputs.wrapper-modules.wrappers.alacritty.wrap {
      inherit pkgs;
      settings = {
        terminal.shell = lib.getExe self'.packages.nushell;
      };
    };
  };
}
