{
  inputs,
  lib,
  config,
  ...
}: {
  options.configurations.nixos = lib.mkOption {
    type = lib.types.lazyAttrsOf (
      lib.types.submodule {
        options = {
          module = lib.mkOption {
            type = lib.types.deferredModule;
          };
          nixpkgsInput = lib.mkOption {
            type = lib.types.str;
            default = "nixpkgs";
          };
          system = lib.mkOption {
            type = lib.types.str;
            default = "x86_64-linux";
          };
        };
      }
    );
    default = {};
  };

  config.flake = {
    nixosConfigurations =
      lib.mapAttrs (
        _: cfg:
          inputs.${cfg.nixpkgsInput}.lib.nixosSystem {
            inherit (cfg) system;
            modules = [cfg.module];
          }
      )
      config.configurations.nixos;

    checks = lib.mkMerge (
      lib.mapAttrsToList (
        name: nixos: {
          ${nixos.config.nixpkgs.hostPlatform.system} = {
            "configurations/nixos/${name}" = nixos.config.system.build.toplevel;
          };
        }
      )
      config.flake.nixosConfigurations
    );
  };
}
