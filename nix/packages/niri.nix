{inputs, ...}: {
  perSystem = {
    pkgs,
    lib,
    self',
    ...
  }: {
    packages.niri = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;
      settings = {
        spawn-at-startup = [
          (lib.getExe self'.packages.noctalia-shell)
        ];
        xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;
        input.keyboard.xkb.layout = "us";
        layout.gaps = 5;
        binds = {
          "Mod+E".show-hotkey-overlay = {};
          "Mod+F".maximize-column = {};
          # Move Focus
          "Mod+J".focus-workspace-down = {};
          "Mod+K".focus-workspace-up = {};
          "Mod+L".focus-column-right = {};
          "Mod+H".focus-column-left = {};
          "Mod+Down".focus-workspace-down = {};
          "Mod+Up".focus-workspace-up = {};
          "Mod+Right".focus-column-right = {};
          "Mod+Left".focus-column-left = {};
          # Move Windows
          "Mod+Shift+J".move-column-to-workspace-down = {};
          "Mod+Shift+K".move-column-to-workspace-up = {};
          "Mod+Shift+L".move-column-right = {};
          "Mod+Shift+H".move-column-left = {};
          "Mod+Shift+Down".move-column-to-workspace-down = {};
          "Mod+Shift+Up".move-column-to-workspace-up = {};
          "Mod+Shift+Right".move-column-right = {};
          "Mod+Shift+Left".move-column-left = {};
          # Monitor Move Focus
          "Mod+Alt+J".focus-monitor-down = {};
          "Mod+Alt+K".focus-monitor-up = {};
          "Mod+Alt+L".focus-monitor-right = {};
          "Mod+Alt+H".focus-monitor-left = {};
          "Mod+Alt+Down".focus-monitor-down = {};
          "Mod+Alt+Up".focus-monitor-up = {};
          "Mod+Alt+Right".focus-monitor-right = {};
          "Mod+Alt+Left".focus-monitor-left = {};
          # Monitor Move Windows
          "Mod+Shift+Alt+J".move-column-to-monitor-down = {};
          "Mod+Shift+Alt+K".move-column-to-monitor-up = {};
          "Mod+Shift+Alt+L".move-column-to-monitor-right = {};
          "Mod+Shift+Alt+H".move-column-to-monitor-left = {};
          "Mod+Shift+Alt+Down".move-column-to-monitor-down = {};
          "Mod+Shift+Alt+Up".move-column-to-monitor-up = {};
          "Mod+Shift+Alt+Right".move-column-to-monitor-right = {};
          "Mod+Shift+Alt+Left".move-column-to-monitor-left = {};
          # Media Controls
          "XF86AudioRaiseVolume".spawn = [(lib.getExe' pkgs.wireplumber "wpctl") "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+"];
          "XF86AudioLowerVolume".spawn = [(lib.getExe' pkgs.wireplumber "wpctl") "set-volume" "@DEFAULT_AUDIO_SINK@j" "0.1-"];
          "XF86AudioMute".spawn = [(lib.getExe' pkgs.wireplumber "wpctl") "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"];
          "XF86AudioMicMute".spawn = [(lib.getExe' pkgs.wireplumber "wpctl") "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"];
          "XF86MonBrightnessUp".spawn = [(lib.getExe pkgs.brightnessctl) "set" "5%+"];
          "XF86MonBrightnessDown".spawn = [(lib.getExe pkgs.brightnessctl) "set" "5%-"];
          "XF86AudioPlay".spawn = [(lib.getExe pkgs.playerctl) "play-pause"];
          "XF86AudioPrev".spawn = [(lib.getExe pkgs.playerctl) "previous"];
          "XF86AudioNext".spawn = [(lib.getExe pkgs.playerctl) "next"];
          # Spawn/Close Programs
          "Mod+Q".spawn-sh = lib.getExe pkgs.kitty;
          "Mod+D".spawn-sh = "${lib.getExe self'.packages.noctalia-shell} ipc call launcher toggle";
          "Mod+U".spawn-sh = "${lib.getExe self'.packages.noctalia-shell} ipc call lockScreen lock";
          "Mod+C".close-window = {};
          "Mod+Escape".quit = {};
        };
        outputs = {
          "DP-4" = {
            mode = "2560x1440@180";
            position = _: {
              props = {
                x = 0;
                y = 0;
              };
            };
          };
          "DP-5" = {
            mode = "2560x1440@180";
            position = _: {
              props = {
                x = 2560;
                y = 0;
              };
            };
          };
          "HDMI-A-2" = {
            mode = "1920x1080@144";
            position = _: {
              props = {
                x = 1280;
                y = -1080;
              };
            };
          };
        };
      };
    };
  };
}
