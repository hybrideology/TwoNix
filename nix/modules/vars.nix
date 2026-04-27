_: {
  flake.modules.nixos.vars = {lib, ...}: {
    options.vars = {
      persistence = {
        enable = lib.mkEnableOption "impermanence";
        dir = lib.mkOption {
          default = "/nix/persist";
          type = lib.types.str;
          description = "Primary impermanence store directory.";
        };
        laDir = lib.mkOption {
          default = "/nix/persist-la";
          type = lib.types.str;
          description = "Secondary impermanence store directory (low-availability, HDD-backed).";
        };
      };
      unfreePkgs = lib.mkOption {
        default = [];
        type = lib.types.listOf lib.types.str;
        description = "List of unfree package names to allow. Modules append to this list.";
      };
    };
  };
}
