{inputs, ...}: {
  flake.modules.nixos.will = {config, ...}: {
    imports = [./_/persistence.nix];
    sops.secrets."will_password".neededForUsers = true;
    users.users.will = {
      uid = 1000; # required for migration script
      isNormalUser = true; # set group to users and creates a home dir
      extraGroups = ["wheel"];
      hashedPasswordFile = config.sops.secrets."will_password".path;
      openssh.authorizedKeys.keyFiles = [./_/assets/will.pub];
      description = "Will";
    };
    home-manager.users.will.imports = [inputs.self.homeModules.will];
  };
}
