_: {
  flake.homeModules.kitty = {
    config,
    lib,
    ...
  }: {
    programs.kitty = {
      enable = true;
      settings =
        {
          enable_audio_bell = false;
          update_check_interval = 0;
        }
        // lib.optionalAttrs config.programs.zsh.enable {
          shell = "${lib.getExe config.programs.zsh.package}";
        };
      extraConfig = "include ~/.config/kitty/themes/noctalia.conf";
    };
  };
}
