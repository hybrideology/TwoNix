_: {
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        after_sleep_cmd = "hyprctl dispatch dpms on"; # to avoid having to press a key a second time after wake
        before_sleep_cmd = "loginctl lock-session";
        lock_cmd = "pidof hyprlock || hyprlock --grace 2";
      };
      listener = [
        {
          timeout = "300";
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = "330";
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        # {
        #   timeout = "1800"; # 30min
        #   on-timeout = "systemctl suspend"; # suspend pc
        # }
      ];
    };
  };
}
