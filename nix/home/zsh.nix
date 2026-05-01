_: {
  flake.homeModules.zsh = {
    lib,
    config,
    ...
  }: {
    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      oh-my-zsh = {
        enable = true;
        plugins = ["colorize" "colored-man-pages" "ssh" "sudo"];
      };
      initContent = ''
        [[ "$TERM" == "xterm-kitty" ]] && alias ssh="TERM=xterm-256color ssh"
      '';
    };
    vars.persistence.files = [".zsh_history"];
    programs.kitty.settings.shell = "${lib.getExe config.programs.zsh.package}";
  };
}
