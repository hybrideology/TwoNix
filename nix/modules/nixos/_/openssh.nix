{config, ...}: let
  cfg = config.vars.openssh;
in {
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
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
  environment.persistence.${config.vars.persistence.dir}.directories = [
    {
      directory = cfg.keyDir;
      mode = "0700";
    }
  ];
}
