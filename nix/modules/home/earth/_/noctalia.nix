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
    "$noctaliaIpc" = "${lib.getExe config.programs.noctalia-shell.package} ipc call";
    exec-once = [
      "uwsm app -- ${lib.getExe config.programs.noctalia-shell.package}"
    ];
    bind = [
      "$mainMod, D, exec, $noctaliaIpc launcher toggle"
      "$mainMod, u, exec, $noctaliaIpc lockScreen lock"
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
