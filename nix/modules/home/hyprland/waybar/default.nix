_: {
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = ''
      * {
        margin: 0 4px;
      }
    '';
    settings = [
      {
        layer = "top";
        position = "top";
        modules-center = ["hyprland/workspaces"];
        modules-left = [
          "privacy"
          "wireplumber"
          "wireplumber#source"
          "cpu"
          "memory"
          "disk"
          "network"
        ];
        modules-right = [
          "custom/power"
          "user"
          "backlight"
          "battery"
          "tray"
          "idle_inhibitor"
          "clock"
        ];
        "hyprland/workspaces" = {
          format = "{name}";
          format-icons = {
            default = " ";
            active = " ";
            urgent = " ";
          };
          on-scroll-up = "hyprctl dispatch workspace e+1";
          on-scroll-down = "hyprctl dispatch workspace e-1";
        };
        clock = {
          tooltip-format = "{:%A, %d.%B %Y }\n<tt><small>{calendar}</small></tt>";
        };
        memory = {
          interval = 5;
          format = " {}%";
        };
        cpu = {
          interval = 5;
          format = " {usage:2}%";
        };
        disk = {
          format = " {free}";
        };
        network = {
          family = "ipv4_6";
          format-icons = [
            "󰤯"
            "󰤟"
            "󰤢"
            "󰤥"
            "󰤨"
          ];
          format-ethernet = "모 {ifname}";
          format-wifi = "{icon} {signalStrength}% {ifname}";
          tooltip-format = "{essid}: {ipaddr}";
          format-disconnected = "󰤮";
        };
        backlight = {
          format = "{icon} {percent}%";
          format-icons = ["" ""];
          tooltip = false;
        };
        wireplumber = {
          format = "{icon} {volume}%";
          format-muted = " --%";
          format-icons = [
            ""
            ""
            ""
          ];
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        };
        "wireplumber#source" = {
          node-type = "Audio/Source";
          format = " {volume}%";
          format-muted = "  --%";
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
        };
        "custom/power" = {
          format = "⏻ ";
          tooltip = false;
          menu = "on-click";
          menu-file = ./power_menu.xml;
          menu-actions = {
            shutdown = "shutdown";
            reboot = "reboot";
            suspend = "systemctl suspend";
            hibernate = "systemctl hibernate";
          };
        };
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
          tooltip = "true";
          tooltip-format-activated = "Idle inhibitor: ON";
          tooltip-format-deactivated = "Idle inhibitor: OFF";
        };
        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-plugged = "󱘖 {capacity}%";
          format-icons = [
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
        };
        privacy = {
          icon-spacing = 4;
          icon-size = 16;
          transition-duration = 250;
          modules = [
            {
              type = "screenshare";
              tooltip = true;
              tooltip-icon-size = 24;
            }
            {
              type = "audio-out";
              tooltip = true;
              tooltip-icon-size = 24;
            }
            {
              type = "audio-in";
              tooltip = true;
              tooltip-icon-size = 24;
            }
          ];
          ignore-monitor = true;
        };
        user = {
          format = "{user}";
          open-on-click = false;
        };
      }
    ];
  };
}
