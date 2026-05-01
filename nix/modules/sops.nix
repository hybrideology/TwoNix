{
  inputs,
  lib,
  ...
}: {
  flake.nixosModules.sops = {config, ...}: let
    cfg = config.vars.sops;
  in {
    imports = [inputs.sops-nix.nixosModules.sops];

    options.vars.sops = {
      dir = lib.mkOption {
        default = "/var/lib/sops";
        type = lib.types.str;
        description = "Directory where sops persists runtime secret state.";
      };
      keyFile = lib.mkOption {
        default = "/age/keys.txt";
        type = lib.types.str;
        description = "Path to the age key file, relative to vars.sops.dir.";
      };
    };

    config = {
      sops = {
        defaultSopsFile = inputs.secrets.secrets;
        age.keyFile = "${config.vars.persistence.dir}${cfg.dir}${cfg.keyFile}";
        age.sshKeyPaths = []; # don't import any ssh keys
      };
      users.mutableUsers = false; # sops manages passwords
      vars.persistence.dirs = [
        {
          directory = cfg.dir;
          mode = "0700";
        }
      ];
    };
  };
}
