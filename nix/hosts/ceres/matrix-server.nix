{
  config,
  inputs,
  ...
}: let
  dirs = config.vars.dataDirs;
  port = builtins.elemAt config.services.matrix-tuwunel.settings.global.port 0;
in {
  sops.secrets = {
    ceres-acme-secrets = {
      sopsFile = inputs.secrets.ceres-acme-secrets;
      mode = "440";
      group = config.users.users.acme.group;
      format = "binary";
    };
    ceres-matrix-registration-token = {
      sopsFile = inputs.secrets.ceres-matrix-registration-token;
      mode = "440";
      group = config.services.matrix-tuwunel.group;
      format = "binary";
    };
  };
  nixpkgs.config.permittedInsecurePackages = [
    "olm-3.2.16"
  ];
  security.acme = {
    acceptTerms = true;
    defaults.email = "skirmish_glove367@simplelogin.com";
    certs."jortpavilion.org" = {
      dnsProvider = "cloudflare";
      environmentFile = config.sops.secrets.ceres-acme-secrets.path;
    };
  };
  networking.firewall.allowedTCPPorts = [443];
  services = {
    nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedBrotliSettings = true;
      recommendedOptimisation = true;
      recommendedTlsSettings = true;
      virtualHosts."jortpavilion.org" = {
        listen = [
          {
            addr = "0.0.0.0";
            port = 443;
            ssl = true;
          }
          {
            addr = "[::]";
            port = 443;
            ssl = true;
          }
        ];
        forceSSL = true;
        enableACME = true;
        acmeRoot = null; # needed for DNS challenge from ACME module
        locations."/" = {
          proxyPass = "http://localhost:${toString port}";
        };
      };
    };
    matrix-tuwunel = {
      enable = true;
      settings.global = {
        address = ["127.0.0.1" "::1"];
        server_name = "jortpavilion.org";
        database_backup_path = "${dirs.archive}/tuwunel";
        database_backups_to_keep = 2;
        ip_lookup_strategy = 4;
        encryption_enabled_by_default_for_room_type = "all";
        allow_registration = true;
        registration_token_file = config.sops.secrets.ceres-matrix-registration-token.path;
        well_known.serve = "jortpavilion.org:443";
      };
    };
    mautrix-discord = {
      enable = true;
      dataDir = "${dirs.apps}/mautrix-discord";
      settings = {
        appservice.database = {
          type = "sqlite3-fk-wal";
          uri = "file:${config.services.mautrix-discord.dataDir}/mautrix-discord.db?_txlock=immediate";
        };
        homeserver = {
          domain = config.services.matrix-tuwunel.settings.global.server_name;
          address = "http://127.0.0.1:${toString port}/";
        };
        bridge = {
          delivery_receipts = true;
          backfill = {
            forward_limits = {
              missed = {
                dm = -1;
                channel = -1;
                thread = -1;
              };
            };
          };
          encryption = {
            allow = true;
            default = true;
            appservice = true;
            msc4190 = true;
            require = true;
            allow_key_sharing = true;
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
