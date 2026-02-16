{config, ...}: let
  dirs = config.vars.dataDirs;
  port = 8008;
  MAX = 50000;
in {
  networking.firewall.allowedTCPPorts = [port];
  nixpkgs.config.permittedInsecurePackages = [
    "olm-3.2.16"
  ];
  services = {
    matrix-synapse = {
      enable = true;
      settings = {
        server_name = "jort.pavilion";
        listeners = [
          {
            bind_addresses = [
              "0.0.0.0"
              "::"
            ];
            port = port;
            resources = [
              {
                compress = true;
                names = [
                  "client"
                ];
              }
              {
                compress = false;
                names = [
                  "federation"
                ];
              }
            ];
            tls = false;
            type = "http";
            x_forwarded = true;
          }
        ];
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
            "@hybrideology:matrix.org" = "admin";
          };
        };
        appservice = {
          address = "http://localhost:${config.services.mautrix-discord.settings.appservice.port}";
          hostname = "127.0.0.1";
          port = 29334;
          ephemeral_events = true;
          database = {
            type = "sqlite3";
            uri = "file:${config.services.mautrix-discord.dataDir}/mautrix-discord.db?_txlock=immediate";
            max_open_conns = 20;
            max_idle_conns = 2;
            max_conn_idle_time = null;
            max_conn_lifetime = null;
          };
        };
      };
    };
  };
}
