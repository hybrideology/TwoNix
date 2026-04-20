{pkgs, ...}: {
  home.packages = [pkgs.git]; # needed for referencing git flakes
  programs.nh.enable = true;
}
