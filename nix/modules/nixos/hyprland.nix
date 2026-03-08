_: {
  programs = {
    hyprland = {
      enable = true;
      withUWSM = true;
    };
    bash.interactiveShellInit = "uwsm start default";
  };
}
