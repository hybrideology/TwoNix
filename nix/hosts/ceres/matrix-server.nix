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
        dataDir = "${dirs.apps}/matrix-synapse/";
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
        appservice = {
          database = {
            type = "postgres";
            uri = "postgres:///mautrix-discord?host=/var/run/postgresql";
          };
        };
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
      };
    };
    postgresql = {
      enable = true;
      ensureDatabases = [
        "matrix-synapse"
        "mautrix-discord"
      ];
      ensureUsers = [
        {
          name = "matrix-synapse";
          ensureDBOwnership = true;
        }
        {
          name = "mautrix-discord";
          ensureDBOwnership = true;
        }
      ];
      authentication = ''
        local all all trust
      '';
      dataDir = "${dirs.db}/postgres/${config.services.postgresql.package.psqlSchema}";
    };
  };
  systemd.tmpfiles.rules = ["d ${config.services.postgresql.dataDir} 700 ${config.users.users.postgres.name} ${config.users.users.postgres.group} -"];
}
