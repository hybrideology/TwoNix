{
  lib,
  osConfig,
  ...
}: {
  wayland.windowManager.hyprland.settings.workspace = lib.optionals (osConfig.networking.hostName == "andromeda") [
    "1, default:true, monitor:DP-4"
    "2, default:true, monitor:HDMI-A-2"
    "3, default:true, monitor:DP-5"
  ];
}
