_: {
  programs.element-desktop = {
    enable = true;
    settings.default_theme = "dark";
  };
  vars.persistence.dirs = [".config/Element"];
}
