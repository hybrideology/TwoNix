flakeArgs: {
  flake.modules.nixos = {
    user-persistence = import ./_/persistence.nix;
    will = {config, ...}: {
      imports = [flakeArgs.config.flake.modules.nixos.user-persistence];
      sops.secrets."will_password".neededForUsers = true;
      users.users.will = {
        uid = 1000; # required for migration script
        isNormalUser = true; # set group to users and creates a home dir
        extraGroups = ["wheel"];
        hashedPasswordFile = config.sops.secrets."will_password".path;
        openssh.authorizedKeys.keyFiles = [./_/assets/will.pub];
        description = "Will";
      };
      home-manager.users.will.imports = [flakeArgs.config.flake.homeModules.will];
    };
  };
}
