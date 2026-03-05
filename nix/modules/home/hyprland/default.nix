{...}: {
  imports = [
    ./hyprlock
    ./waybar
    ./binds.nix
    ./decoration.nix
    ./fuzzel.nix
    ./general.nix
    ./hypridle.nix
    ./hyprpaper.nix
    ./hyprpicker.nix
    ./hyprpolkitagent.nix
    ./hyprshot.nix
    ./input.nix
    ./misc.nix
    ./monitors.nix
    ./workspaces.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false; # disable systemd integration to use UWSM
  };
  vars.persistence.dirs = [".local/share/hyprland"];
}
