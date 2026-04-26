_: {
  flake.homeModules.element-desktop = _: {
    programs.element-desktop = {
      enable = true;
      settings.default_theme = "dark";
    };
    vars.persistence.dirs = [".config/Element"];
  };
}
