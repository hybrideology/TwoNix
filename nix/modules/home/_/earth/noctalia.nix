{
  config,
  lib,
  pkgs,
  ...
}: {
  vars.persistence.dirs = [
    ".config/noctalia"
    ".local/share/noctalia"
  ];

  programs.noctalia-shell = {
    enable = true;
    settings = lib.mkDefault ./noctalia-settings.json;
  };

  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "uwsm app -- ${lib.getExe config.programs.noctalia-shell.package}"
    ];
    bind = [
      "$mainMod, D, exec, qs -c noctalia-shell ipc call launcher toggle"
      "$mainMod, u, exec, qs -c noctalia-shell ipc call lockScreen lock"
    ];
  };

  home = {
    pointerCursor = {
      package = pkgs.phinger-cursors;
      name = "phinger-cursors-light";
      size = 32;
      gtk.enable = true;
    };
    packages = with pkgs; [
      noto-fonts
      nerd-fonts.symbols-only
    ];
  };

  fonts.fontconfig.enable = true;
}
