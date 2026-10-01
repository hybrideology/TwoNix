{inputs, ...}: {
  perSystem = {
    pkgs,
    self',
    lib,
    ...
  }: {
    packages.alacritty = inputs.wrapper-modules.wrappers.alacritty.wrap {
      inherit pkgs;
      settings = {
        terminal.shell = lib.getExe self'.packages.fish;
      };
    };
  };
}
