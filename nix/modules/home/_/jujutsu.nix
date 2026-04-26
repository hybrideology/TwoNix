{pkgs, ...}: {
  programs.jujutsu.enable = true;
  home.packages = [pkgs.git];
  vars.persistence.dirs = [".config/jj"];
}
