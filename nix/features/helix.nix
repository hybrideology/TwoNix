{inputs, ...}: {
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
