{
  config,
  lib,
  ...
}: {
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) config.vars.unfreePkgs;
}
