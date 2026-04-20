{
  config,
  lib,
  ...
}: {
  programs.kitty = {
    enable = true;
    settings = {
      enable_audio_bell = false;
      update_check_interval = 0;
    };
  };
  wayland.windowManager.hyprland.settings.bind = [
    "$mainMod, Q, exec, uwsm app -- ${lib.getExe config.programs.kitty.package}"
  ];
}
