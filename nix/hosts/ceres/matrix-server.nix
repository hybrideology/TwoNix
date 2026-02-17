{config, ...}: let
  dirs = config.vars.dataDirs;
  matrix-server-dir = "${dirs.apps}/matrix-synapse/";
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
        signing_key_path = "${matrix-server-dir}/homeserver.signing.key";
        media_store_path = "${matrix-server-dir}/media";
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
      };
    };
    postgresql = {
      enable = true;
      authentication = ''
        local all all trust
      '';
      dataDir = "${dirs.apps}/postgresql/${config.services.postgresql.package.psqlSchema}";
    };
  };
}
