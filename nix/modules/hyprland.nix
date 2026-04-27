_: {
  flake.modules.nixos.hyprland = _: {
    programs = {
      hyprland = {
        enable = true;
        withUWSM = true;
      };
      bash.loginShellInit = ''
        [ "$(tty)" = "/dev/tty1" ] && exec uwsm start default
      '';
    };
  };
}
