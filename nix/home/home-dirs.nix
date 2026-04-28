_: {
  flake.homeModules.home-dirs = _: {
    vars.persistence = {
      laDirs = [
        "Documents"
        "Downloads"
        "Games"
        "Music"
        "Pictures"
        "Videos"
      ];
      dirs = [
        ".config/dconf"
        ".local/state/wireplumber"
        "git"
      ];
      files = [".config/mimeapps.list"];
    };
  };
}
