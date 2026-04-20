{
  config,
  lib,
  ...
}: {
  services.mako = {
    enable = true;
    settings.max-history = 50;
  };
  wayland.windowManager.hyprland.settings.exec-once = [
    "uwsm app -- ${lib.getExe config.services.mako.package}"
  ];
}
