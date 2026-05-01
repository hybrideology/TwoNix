{inputs, ...}: {
  flake.homeModules.will = {config, ...}: let
    primaryEmail = "a7bcf569-bbfe-46d1-ac8b-4e8c9bc380ef@anonaddy.me";
    githubEmail = "30223844+hybrideology@users.noreply.github.com";
    userName = "hybrideology";
  in {
    sops = {
      defaultSopsFile = inputs.secrets.will;
      secrets."ssh_key".path = "${config.home.homeDirectory}/.ssh/${config.home.username}";
    };
    home = {
      username = "will";
      homeDirectory = "/home/will";
    };
    programs = {
      ssh.matchBlocks."*".identityFile = config.sops.secrets."ssh_key".path;
      git = {
        settings.user = {
          email = primaryEmail;
          name = userName;
        };
        includes = [
          {
            condition = "gitdir:~/git/github";
            contents.user.email = githubEmail;
          }
        ];
      };
      jujutsu.settings = {
        user = {
          email = primaryEmail;
          name = userName;
        };
        "--scope" = [
          {
            "--when".repositories = ["~/git/github"];
            user.email = githubEmail;
          }
        ];
      };
    };
  };
}
