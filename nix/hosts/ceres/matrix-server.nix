{config, ...}: let
  dirs = config.vars.dataDirs;
  ports = config.services.matrix-tuwunel.settings.global.port;
  MAX = "50000";
in {
  networking.firewall.allowedTCPPorts = ports;
  services = {
    matrix-tuwunel = {
      enable = true;
      settings.global = {
        address = ["0.0.0.0" "::"];
        server_name = "jort.pavilion";
        database_backup_path = "${dirs.archive}/tuwunel";
        database_backup_paths_to_keep = 2;
        ip_lookup_strategy = 4;
        encryption_enabled_by_default_for_room_type = "all";
      };
    };
    mautrix-discord = {
      enable = true;
      dataDir = "${dirs.apps}/mautrix-discord";
      settings = {
        homeserver = {
          domain = config.services.matrix-tuwunel.settings.global.server_name;
          address = "http://127.0.0.1:${toString (builtins.elemAt ports 0)}/";
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
                dm = "-1";
                channel = "-1";
                thread = "-1";
              };
            };
          };
          permissions = {
            "*" = "relay";
            "@hybrideology:matrix.org" = "admin";
          };
        };
        appservice = {
          address = "http://localhost:${config.services.mautrix-discord.settings.appservice.port}";
          hostname = "127.0.0.1";
          port = "29334";
          ephemeral_events = true;
        };
      };
    };
  };
}
