_: {
  flake.homeModules.ssh = _: {
    services.ssh-agent.enable = true;
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings = {
        "*" = {
          host = "*";
          hashKnownHosts = true;
          addKeysToAgent = "1h";
        };
      };
    };
    vars.persistence.dirs = [
      {
        directory = ".ssh";
        mode = "0700";
      }
    ];
  };
}
