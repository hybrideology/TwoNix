{
  inputs,
  self,
  ...
}: {
  flake.nixosModules.helix = {pkgs, ...}: {
    environment.systemPackages = [self.packages.${pkgs.stdenv.hostPlatform.system}.helix];
  };
  perSystem = {
    pkgs,
    lib,
    ...
  }: {
    packages.helix = inputs.wrapper-modules.wrappers.helix.wrap {
      inherit pkgs;
      languages = {
        language-server = {
          nixd = {
            command = "${lib.getExe pkgs.nixd}";
          };
        };
        language = [
          {
            name = "nix";
            auto-format = true;
            formatter.command = lib.getExe pkgs.alejandra;
          }
        ];
      };
    };
  };
}
