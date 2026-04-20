{config, ...}: {
  sops.secrets."will_password".neededForUsers = true;
  imports = [./persistence.nix];
  users.users.will = {
    uid = 1000; # required for migration script
    isNormalUser = true; # set group to users and creates a home dir
    extraGroups = ["wheel"];
    hashedPasswordFile = config.sops.secrets."will_password".path;
    openssh.authorizedKeys.keyFiles = [./assets/will.pub];
    description = "Will";
  };
}
