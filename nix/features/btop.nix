{
  inputs,
  self,
  ...
}: {
  flake.nixosModules.btop = {pkgs, ...}: {
    environment.systemPackages = [self.packages.${pkgs.stdenv.hostPlatform.system}.btop];
  };
  perSystem = {pkgs, ...}: {
    packages.btop = inputs.wrapper-modules.wrappers.btop.wrap {
      inherit pkgs;
      settings = {
        theme_background = false;
        proc_tree = true;
      };
    };
  };
}
