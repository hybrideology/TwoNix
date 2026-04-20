_: {
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
  programs.kitty.settings.shell = "zsh";
  vars.persistence.files = [".zsh_history"];
}
