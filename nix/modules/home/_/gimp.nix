{pkgs, ...}: {
  home.packages = [
    pkgs.gimp
  ];
  vars.persistence.dirs = [".config/GIMP"];
}
