{pkgs, ...}: {
  programs.jujutsu.enable = true;
  home.packages = [pkgs.git];
}
