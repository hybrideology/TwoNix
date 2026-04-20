{pkgs, ...}: {
  home.packages = [pkgs.godot];
  vars.persistence.dirs = [".config/godot" ".local/share/godot"];
}
