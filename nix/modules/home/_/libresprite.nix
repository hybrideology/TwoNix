{pkgs, ...}: {
  home.packages = [pkgs.libresprite];
  vars.persistence.dirs = [".config/libresprite"];
}
