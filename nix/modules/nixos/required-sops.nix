_: {
  flake.modules.nixos.sops-defaults = {
    config,
    lib,
    ...
  }: let
    cfg = config.vars.sops;
  in {
    options.vars.sops = {
      dir = lib.mkOption {
        default = "/var/lib/sops";
        type = lib.types.str;
      };
      keyFile = lib.mkOption {
        default = "/age/keys.txt";
        type = lib.types.str;
      };
    };
    config = {
      sops = {
        age.keyFile = "${config.vars.persistence.dir}${cfg.dir}${cfg.keyFile}";
        age.sshKeyPaths = []; # don't import any ssh keys
      };
      users.mutableUsers = false; # sops manages passwords
      environment.persistence.${config.vars.persistence.dir}.directories = [config.vars.sops.dir];
    };
  };
}
