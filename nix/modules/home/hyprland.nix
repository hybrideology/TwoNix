_: {
  flake.homeModules.hyprland = {
    lib,
    config,
    pkgs,
    ...
  }: {
    options.vars.hyprland = {
      monitors = lib.mkOption {
        default = [];
        type = lib.types.listOf lib.types.str;
      };
      workspaces = lib.mkOption {
        default = [];
        type = lib.types.listOf lib.types.str;
      };
    };

    config = {
      wayland.windowManager.hyprland = {
        enable = true;
        systemd.enable = false; # disable systemd integration to use UWSM
        settings = {
          "$mainMod" = "super";

          bind = [
            "$mainMod, c, killactive,"
            "$mainMod, escape, exit,"
            "$mainMod, f, fullscreen, 0"
            "$mainMod, s, togglefloating"
            "$mainMod alt, P, exec, uwsm app -- hyprpicker -ar"
            "$mainMod, P, exec, uwsm app -- ${lib.getExe config.programs.hyprshot.package} -m region -z --raw | satty -f -"
            "$mainMod, left, workspace, r-1"
            "$mainMod, right, workspace, r+1"
            "$mainMod, down, togglespecialworkspace, drawer"
            "$mainMod, up, togglespecialworkspace, drawer"
            "$mainMod shift, left, movetoworkspace, r-1"
            "$mainMod shift, right, movetoworkspace, r+1"
            "$mainMod shift, down, movetoworkspace, r+0"
            "$mainMod shift, up, movetoworkspace, special:drawer"
            "$mainMod alt, left, movefocus, l"
            "$mainMod alt, right, movefocus, r"
            "$mainMod alt, down, movefocus, d"
            "$mainMod alt, up, movefocus, u"
            "$mainMod shift alt, left, movewindow, l"
            "$mainMod shift alt, right, movewindow, r"
            "$mainMod shift alt, down, movewindow, d"
            "$mainMod shift alt, up, movewindow, u"

            "$mainMod, h, workspace, r-1"
            "$mainMod, l, workspace, r+1"
            "$mainMod, j, togglespecialworkspace, drawer"
            "$mainMod, k, togglespecialworkspace, drawer"
            "$mainMod shift, h, movetoworkspace, r-1"
            "$mainMod shift, l, movetoworkspace, r+1"
            "$mainMod shift, j, movetoworkspace, r+0"
            "$mainMod shift, k, movetoworkspace, special:drawer"
            "$mainMod alt, h, movefocus, l"
            "$mainMod alt, l, movefocus, r"
            "$mainMod alt, j, movefocus, d"
            "$mainMod alt, k, movefocus, u"
            "$mainMod shift alt, h, movewindow, l"
            "$mainMod shift alt, l, movewindow, r"
            "$mainMod shift alt, j, movewindow, d"
            "$mainMod shift alt, k, movewindow, u"

            "$mainMod, m, focusmonitor, +1"
            "$mainMod shift, m, movewindow, mon:+1"
          ];

          bindel = [
            ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
            ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
            ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
            ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
          ];

          bindl = [
            ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
            ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
            ", XF86AudioPlay, exec, playerctl play-pause"
            ", XF86AudioPrev, exec, playerctl previous"
            ", XF86AudioNext, exec, playerctl next"
          ];

          bindm = [
            # Move/resize windows with mainMod + LMB/RMB and dragging
            "$mainMod, mouse:272, movewindow"
            "$mainMod, mouse:273, resizewindow"
          ];

          decoration = {
            rounding = "8";
            dim_inactive = "true";
            dim_strength = "0.1";
            blur.passes = "3";
            shadow.range = "5";
          };

          general = {
            border_size = "2";
            gaps_in = "5";
            gaps_out = "5";
            snap.enabled = true;
          };

          misc = {
            disable_hyprland_logo = true;
            disable_splash_rendering = true;
            focus_on_activate = true; # apps can request focus
          };

          input = {
            touchpad = {
              natural_scroll = true;
              disable_while_typing = true;
            };
            tablet.output = "current";
          };

          monitor =
            [
              ",preferred,auto,1" # for plugging in random monitors
            ]
            ++ config.vars.hyprland.monitors;

          workspace = config.vars.hyprland.workspaces;
        };
      };

      services.hyprpolkitagent.enable = true;

      programs.hyprshot = {
        enable = true;
        saveLocation = "${config.home.homeDirectory}/Pictures/hyprshot";
      };

      home.packages = [
        pkgs.brightnessctl
        pkgs.playerctl
        pkgs.hyprpicker
        pkgs.wl-clipboard
        pkgs.satty
      ];

      vars.persistence.dirs = [".local/share/hyprland"];
    };
  };
}
