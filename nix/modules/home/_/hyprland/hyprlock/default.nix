{
  config,
  lib,
  pkgs,
  ...
}: let
  font = config.stylix.fonts.monospace.name;
  font_bold = "${config.stylix.fonts.monospace.name} ExtraBold";
  whatsong = import ./whatsong.nix pkgs;
in {
  home.packages = [
    pkgs.playerctl # required for scripts
  ];
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
      };
      background = lib.mkForce [
        {
          path = toString config.stylix.image; # use stylix image
          blur_passes = 3; # smooth blur
        }
      ];
      image = [
        # Music
        {
          monitor = "";
          path = "";
          size = 60; # lesser side if not 1:1 ratio
          rounding = 5; # negative values mean circle
          reload_time = 1;
          reload_cmd = "${whatsong} --arturl";
          position = "740, 45"; # offset from center bottom
          halign = "left";
          valign = "bottom";
        }
      ];
      label = [
        # Date
        {
          monitor = "";
          text = ''cmd[update:1000] echo "$(date +"%A, %B %d")"''; # get the date
          color = "rgba(${config.lib.stylix.colors.base07}F0)";
          font_size = 22;
          font_family = font;
          position = "0, 280"; # offset from center of screen
          halign = "center";
          valign = "center";
        }
        # Time
        {
          monitor = "";
          text = ''cmd[update:1000] echo "$TIME"''; # time provided by hyprlock
          color = "rgba(${config.lib.stylix.colors.base07}F0)";
          font_size = "95";
          font_family = font_bold;
          position = "0, 200"; # offset from center of screen
          halign = "center";
          valign = "center";
        }
        # User Greeting
        {
          monitor = "";
          text = "Welcome, $DESC."; # description provided by user
          color = "rgba(${config.lib.stylix.colors.base07}F0)";
          font_size = 22;
          font_family = font;
          position = "0, 100"; # offset from center of screen
          halign = "center";
          valign = "center";
        }
        # Player Title
        {
          monitor = "";
          text = ''cmd[update:1000] echo "$(${whatsong} --title)"'';
          color = "rgba(${config.lib.stylix.colors.base07}F0)";
          font_size = 12;
          font_family = font;
          position = "860, 90";
          halign = "left";
          valign = "bottom";
        }
        # Player Length
        {
          monitor = "";
          text = ''cmd[update:1000] echo "$(${whatsong} --length) "'';
          color = "rgba(${config.lib.stylix.colors.base07}F0)";
          font_size = 11;
          font_family = font;
          position = "-740, 70";
          halign = "right";
          valign = "bottom";
        }
        # Player Status
        {
          monitor = "";
          text = ''cmd[update:1000] echo "$(${whatsong} --status)"'';
          color = "rgba(${config.lib.stylix.colors.base07}F0)";
          font_size = 14;
          font_family = font;
          position = "-740, 70";
          halign = "right";
          valign = "bottom";
        }
        # Player Source
        {
          monitor = "";
          text = ''cmd[update:1000] echo "$(${whatsong} --source)"'';
          color = "rgba(${config.lib.stylix.colors.base07}F0)";
          font_size = 10;
          font_family = font;
          position = "-740, 50";
          halign = "right";
          valign = "bottom";
        }
        # Player Album
        {
          monitor = "";
          text = ''cmd[update:1000] echo "$(${whatsong} --album)"'';
          color = "rgba(${config.lib.stylix.colors.base07}F0)";
          font_size = 10;
          font_family = font;
          position = "860, 50";
          halign = "left";
          valign = "bottom";
        }
        # Player Artist
        {
          monitor = "";
          text = ''cmd[update:1000] echo "$(${whatsong} --artist)"'';
          color = "rgba(${config.lib.stylix.colors.base07}F0)";
          font_size = 10;
          font_family = font;
          position = "860, 70";
          halign = "left";
          valign = "bottom";
        }
      ];
    };
  };
}
