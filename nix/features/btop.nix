{inputs, ...}: {
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
