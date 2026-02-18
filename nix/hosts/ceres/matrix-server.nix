{
  config,
  inputs,
  ...
}: let
  dirs = config.vars.dataDirs;
  port = builtins.elemAt config.services.matrix-tuwunel.settings.global.port 0;
  MAX = 50000;
in {
  sops.secrets.ceres-matrix-registration-token = {
    sopsFile = inputs.secrets.ceres-matrix-registration-token;
    mode = "440";
    group = config.services.matrix-tuwunel.group;
    format = "binary";
  };
  networking.firewall.allowedTCPPorts = config.services.matrix-tuwunel.settings.global.port;
  nixpkgs.config.permittedInsecurePackages = [
    "olm-3.2.16"
  ];
  services = {
    matrix-tuwunel = {
      enable = true;
      settings.global = {
        address = ["0.0.0.0" "::"];
        server_name = "jortpavilion.org";
        database_backup_path = "${dirs.archive}/tuwunel";
        database_backup_paths_to_keep = 2;
        ip_lookup_strategy = 4;
        encryption_enabled_by_default_for_room_type = "all";
        allow_registration = true;
        registration_token_file = config.sops.secrets.ceres-matrix-registration-token.path;
      };
    };
    mautrix-discord = {
      enable = true;
      dataDir = "${dirs.apps}/mautrix-discord";
      settings = {
        homeserver = {
          domain = config.services.matrix-synapse.settings.server_name;
          address = "http://127.0.0.1:${toString port}/";
        };
        bridge = {
          backfill = {
            forward_limits = {
              initial = {
                dm = MAX;
                channel = MAX;
                thread = MAX;
              };
              missed = {
                dm = -1;
                channel = -1;
                thread = -1;
              };
            };
          };
          permissions = {
            "*" = "relay";
            "@hybrideology:${config.services.matrix-tuwunel.settings.global.server_name}" = "admin";
          };
        };
      };
    };
  };
}
