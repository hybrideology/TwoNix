_: {
  flake.homeModules.hyprland = {
    lib,
    config,
    pkgs,
    ...
  }: let
    mkDirectionalBinds = mods: commands: [
      "${mods}, left, ${commands.left}"
      "${mods}, h, ${commands.left}"
      "${mods}, down, ${commands.down}"
      "${mods}, j, ${commands.down}"
      "${mods}, up, ${commands.up}"
      "${mods}, k, ${commands.up}"
      "${mods}, right, ${commands.right}"
      "${mods}, l, ${commands.right}"
    ];
  in {
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
          "$screenPicker" = "uwsm app -- ${lib.getExe pkgs.hyprpicker} -ar";
          "$regionShot" = "uwsm app -- ${lib.getExe config.programs.hyprshot.package} -m region -z --raw | ${lib.getExe pkgs.satty} -f -";
          "$volumeUp" = "${lib.getExe' pkgs.wireplumber "wpctl"} set-volume @DEFAULT_AUDIO_SINK@ 5%+";
          "$volumeDown" = "${lib.getExe' pkgs.wireplumber "wpctl"} set-volume @DEFAULT_AUDIO_SINK@ 5%-";
          "$volumeMute" = "${lib.getExe' pkgs.wireplumber "wpctl"} set-mute @DEFAULT_AUDIO_SINK@ toggle";
          "$micMute" = "${lib.getExe' pkgs.wireplumber "wpctl"} set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
          "$brightnessUp" = "${lib.getExe pkgs.brightnessctl} set 5%+";
          "$brightnessDown" = "${lib.getExe pkgs.brightnessctl} set 5%-";
          "$playerPlayPause" = "${lib.getExe pkgs.playerctl} play-pause";
          "$playerPrev" = "${lib.getExe pkgs.playerctl} previous";
          "$playerNext" = "${lib.getExe pkgs.playerctl} next";

          bind =
            [
              "$mainMod, c, killactive,"
              "$mainMod, escape, exit,"
              "$mainMod, f, layoutmsg, fit"
              "$mainMod shift, f, fullscreen, 0"
              "$mainMod, s, togglefloating"
              "$mainMod shift, P, exec, $screenPicker"
              "$mainMod, P, exec, $regionShot"
            ]
            ++ (mkDirectionalBinds "$mainMod" {
              left = "movefocus, l";
              down = "movefocus, d";
              up = "movefocus, u";
              right = "movefocus, r";
            })
            ++ (mkDirectionalBinds "$mainMod shift" {
              left = "movewindow, l";
              down = "movewindow, d";
              up = "movewindow, u";
              right = "movewindow, r";
            })
            ++ [
              "$mainMod ctrl, left, layoutmsg, colresize -0.1"
              "$mainMod ctrl, h, layoutmsg, colresize -0.1"
              "$mainMod ctrl, right, layoutmsg, colresize +0.1"
              "$mainMod ctrl, l, layoutmsg, colresize +0.1"
            ];

          bindel = [
            ", XF86AudioRaiseVolume, exec, $volumeUp"
            ", XF86AudioLowerVolume, exec, $volumeDown"
            ", XF86MonBrightnessUp, exec, $brightnessUp"
            ", XF86MonBrightnessDown, exec, $brightnessDown"
          ];

          bindl = [
            ", XF86AudioMute, exec, $volumeMute"
            ", XF86AudioMicMute, exec, $micMute"
            ", XF86AudioPlay, exec, $playerPlayPause"
            ", XF86AudioPrev, exec, $playerPrev"
            ", XF86AudioNext, exec, $playerNext"
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
            layout = "scrolling";
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
        pkgs.wireplumber
        pkgs.wl-clipboard
        pkgs.satty
      ];

      vars.persistence.dirs = [".local/share/hyprland"];
    };
  };
}
