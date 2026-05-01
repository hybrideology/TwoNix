_: {
  flake.nixosModules.openssh = {
    config,
    lib,
    ...
  }: let
    cfg = config.vars.openssh;
  in {
    options.vars.openssh = {
      keyDir = lib.mkOption {
        default = "/etc/ssh/ssh_host_keys";
        type = lib.types.str;
        description = "Directory where SSH host keys are stored and persisted.";
      };
      allowedGroups = lib.mkOption {
        default = ["wheel"];
        type = lib.types.listOf lib.types.str;
        description = "Groups permitted to connect via SSH.";
      };
    };
    config = {
      services.openssh = {
        enable = true;
        settings = {
          PermitRootLogin = "no";
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
          AllowGroups = cfg.allowedGroups;
        };
        hostKeys = [
          {
            bits = 4096;
            path = "${cfg.keyDir}/ssh_host_rsa_key";
            type = "rsa";
          }
          {
            path = "${cfg.keyDir}/ssh_host_ed25519_key";
            type = "ed25519";
          }
        ];
      };
      vars.persistence.dirs = [
        {
          directory = cfg.keyDir;
          mode = "0700";
        }
      ];
    };
  };
}
