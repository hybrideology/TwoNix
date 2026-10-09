{
  inputs,
  self,
  ...
}: {
  flake.nixosModules.noctalia-shell = {pkgs, ...}: {
    environment.systemPackages = [self.packages.${pkgs.stdenv.hostPlatform.system}.noctalia-shell];
  };
  perSystem = {pkgs, ...}: {
    packages.noctalia-shell = inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
      inherit pkgs;
      inherit
        ((builtins.fromJSON
          (builtins.readFile ./noctalia-shell.json)))
        settings
        ;
    };
  };
}
