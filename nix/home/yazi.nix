_: {
  flake.homeModules.yazi = _: {
    programs.yazi = {
      enable = true;
      shellWrapperName = "y";
    };
    vars.persistence.dirs = [".local/state/yazi"];
  };
}
