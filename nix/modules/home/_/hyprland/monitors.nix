{
  lib,
  osConfig,
  ...
}: {
  wayland.windowManager.hyprland.settings.monitor =
    [
      ",preferred,auto,1" # for plugging in random monitors
    ]
    ++ lib.optionals (osConfig.networking.hostName == "andromeda") [
      "DP-4, 2560x1440@180, 0x0, 1, bitdepth, 10"
      "DP-5, 2560x1440@180, 2560x0, 1, bitdepth, 10"
      "HDMI-A-2, 1920x1080@144, 1600x-1080, 1"
    ];
}
