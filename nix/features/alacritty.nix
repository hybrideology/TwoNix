{inputs, ...}: {
  perSystem = {pkgs, ...}: {
    packages.alacritty = inputs.wrapper-modules.wrappers.alacritty.wrap {
      inherit pkgs;
    };
  };
}
