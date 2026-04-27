{inputs, ...}: {
  home-manager.users.will = {
    imports = [inputs.self.homeModules.earth];
    home.stateVersion = "25.11";
    vars.hyprland = {
      monitors = [
        "DP-4, 2560x1440@180, 0x0, 1, bitdepth, 10"
        "DP-5, 2560x1440@180, 2560x0, 1, bitdepth, 10"
        "HDMI-A-2, 1920x1080@144, 1600x-1080, 1"
      ];
      workspaces = [
        "1, default:true, monitor:DP-4"
        "2, default:true, monitor:HDMI-A-2"
        "3, default:true, monitor:DP-5"
      ];
    };
  };
}
