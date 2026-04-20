{
  inputs,
  config,
  ...
}: {
  imports = [./sops.nix];
  home = {
    username = "will";
    homeDirectory = "/home/will";
  };
  sops = {
    defaultSopsFile = inputs.secrets.will;
    age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
    secrets."ssh_key".path = "${config.home.homeDirectory}/.ssh/${config.home.username}";
  };
  programs = {
    ssh.matchBlocks."*".identityFile = config.sops.secrets."ssh_key".path;
    git = {
      settings.user = {
        email = "git.panic703@simplelogin.com";
        name = "hybrideology";
      };
      includes = [
        {
          condition = "gitdir:~/git/github";
          contents.user.email = "30223844+hybrideology@users.noreply.github.com";
        }
      ];
    };
    jujutsu.settings = {
      user = {
        email = "git.panic703@simplelogin.com";
        name = "hybrideology";
      };
      "--scope" = [
        {
          "--when".repositories = ["~/git/github"];
          user.email = "30223844+hybrideology@users.noreply.github.com";
        }
      ];
    };
  };
}
