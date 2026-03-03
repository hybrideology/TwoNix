{
  config,
  inputs,
  ...
}: let
  dirs = config.vars.dataDirs;
  port = builtins.elemAt config.services.matrix-tuwunel.settings.global.port 0;
  domain = "jortpavilion.org";
  turn-domain = "turn.${domain}";
  # mrtc-domain = "matrix-rtc.${domain}";
in {
  sops.secrets = {
    ceres-acme-secrets = {
      sopsFile = inputs.secrets.ceres-acme-secrets;
      mode = "440";
      group = config.users.users.acme.group;
      format = "binary";
    };
    coturn_static_secret = {
      sopsFile = inputs.secrets.ceres;
      mode = "440";
      group = config.users.users.turnserver.group;
    };
    matrix_registration_token = {
      sopsFile = inputs.secrets.ceres;
      mode = "440";
      group = config.services.matrix-tuwunel.group;
    };
    ceres-mautrix-discord-secrets = {
      sopsFile = inputs.secrets.ceres-mautrix-discord-secrets;
      mode = "440";
      group = config.users.users.mautrix-discord.group;
      format = "binary";
    };
    # ceres-matrix-rtc-keys = {
    #   sopsFile = inputs.secrets.ceres-matrix-rtc-keys;
    #   mode = "440";
    #   group = config.users.users.mautrix-discord.group;
    #   format = "binary";
    # };
  };
  users.users.tuwunel.extraGroups = [config.users.users.turnserver.group]; # allows tuwunel to read secret
  nixpkgs.config.permittedInsecurePackages = [
    "olm-3.2.16"
  ];
  security.acme = {
    acceptTerms = true;
    defaults.email = "skirmish_glove367@simplelogin.com";
    certs = {
      ${domain} = {
        dnsProvider = "cloudflare";
        environmentFile = config.sops.secrets.ceres-acme-secrets.path;
      };
      ${turn-domain} = {
        dnsProvider = "cloudflare";
        environmentFile = config.sops.secrets.ceres-acme-secrets.path;
        postRun = "systemctl restart coturn.service";
        group = config.users.users.turnserver.group;
      };
      # ${mrtc-domain} = {
      #   dnsProvider = "cloudflare";
      #   environmentFile = config.sops.secrets.ceres-acme-secrets.path;
      #   postRun = "systemctl restart livekit.service";
      # };
    };
  };
  networking.firewall = {
    allowedTCPPorts = [
      443
      config.services.coturn.listening-port
      config.services.coturn.tls-listening-port
    ];
    allowedUDPPorts = [
      config.services.coturn.listening-port
      config.services.coturn.tls-listening-port
    ];
    allowedTCPPortRanges = [
      {
        from = config.services.coturn.min-port;
        to = config.services.coturn.max-port;
      }
    ];
    allowedUDPPortRanges = [
      {
        from = config.services.coturn.min-port;
        to = config.services.coturn.max-port;
      }
    ];
  };
  services = {
    nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedBrotliSettings = true;
      recommendedOptimisation = true;
      recommendedTlsSettings = true;
      virtualHosts.${domain} = {
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
          proxyPass = "http://127.0.0.1:${toString port}";
        };
      };
    };
    coturn = {
      enable = true;
      no-cli = true;
      use-auth-secret = true;
      static-auth-secret-file = config.sops.secrets.coturn_static_secret.path;
      realm = turn-domain;
      cert = "${config.security.acme.certs.${turn-domain}.directory}/full.pem";
      pkey = "${config.security.acme.certs.${turn-domain}.directory}/key.pem";
    };
    matrix-tuwunel = {
      enable = true;
      settings.global = {
        address = ["127.0.0.1"];
        server_name = domain;
        database_backup_path = "${dirs.archive}/tuwunel";
        database_backups_to_keep = 2;
        ip_lookup_strategy = 4;
        encryption_enabled_by_default_for_room_type = "invite";
        allow_registration = true;
        registration_token_file = config.sops.secrets.matrix_registration_token.path;
        turn_secret_file = config.sops.secrets.coturn_static_secret.path;
        turn_uris = [
          "turn:${config.services.coturn.realm}?transport=udp"
          "turns:${config.services.coturn.realm}?transport=udp"
          "turn:${config.services.coturn.realm}?transport=tcp"
          "turns:${config.services.coturn.realm}?transport=tcp"
        ];
        well_known.server = "${domain}:443";
      };
    };
    mautrix-discord = {
      enable = true;
      dataDir = "${dirs.apps}/mautrix-discord";
      environmentFile = config.sops.secrets.ceres-mautrix-discord-secrets.path;
      settings = {
        appservice = {
          hostname = "127.0.0.1";
          database = {
            type = "sqlite3-fk-wal";
            uri = "file:${config.services.mautrix-discord.dataDir}/mautrix-discord.db?_txlock=immediate";
          };
        };
        homeserver = {
          domain = domain;
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
            plaintext_mentions = true;
          };
          permissions = {
            "*" = "relay";
            "${domain}" = "user";
            "@hybrideology:${domain}" = "admin";
          };
          login_shared_secret_map.${domain} = "as_token:$DOUBLE_PUPPET_AS_TOKEN";
        };
      };
    };
  };
}
