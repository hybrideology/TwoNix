_: {
  flake.homeModules.remmina = _: {
    services.remmina = {
      enable = true;
      systemdService.enable = true;
    };
    vars.persistence.dirs = [
      ".local/share/remmina"
      ".config/remmina"
    ];
  };
}
