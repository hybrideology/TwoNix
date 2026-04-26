{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.noctalia-shell = {
    enable = true;
    settings = lib.mkDefault (builtins.fromJSON (builtins.readFile ./noctalia-settings.json));
  };
  wayland.windowManager.hyprland.settings.exec-once = [
    "uwsm app -- ${lib.getExe config.programs.noctalia-shell.package}"
  ];

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
