_: {
  flake.nixosModules.nixpkgs = {
    config,
    lib,
    ...
  }: {
    options.vars.unfreePkgs = lib.mkOption {
      default = [];
      type = lib.types.listOf lib.types.str;
      description = "List of unfree package names to allow. Modules append to this list.";
    };
    config.nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) config.vars.unfreePkgs;
  };
}
