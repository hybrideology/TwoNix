{
  inputs,
  self,
  ...
}: {
  flake.nixosModules.yazi = {pkgs, ...}: {
    environment.systemPackages = [self.packages.${pkgs.stdenv.hostPlatform.system}.yazi];
  };
  perSystem = {pkgs, ...}: {
    packages.yazi = inputs.wrapper-modules.wrappers.yazi.wrap {
      inherit pkgs;
    };
  };
}
