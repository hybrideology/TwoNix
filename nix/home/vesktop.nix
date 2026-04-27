_: {
  flake.homeModules.vesktop = _: {
    programs.vesktop.enable = true;
    vars.persistence.dirs = [
      ".config/vesktop"
      ".pki"
    ];
  };
}
