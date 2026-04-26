{config, ...}: let
  dirs = config.vars.dataDirs;
  port = builtins.elemAt config.services.matrix-tuwunel.settings.global.port 0;
  domain = "jortpavilion.org";
  turn-domain = "turn.${domain}";
  # mrtc-domain = "matrix-rtc.${domain}";
in {
  sops.secrets = {
    ceres-acme-secrets = {
      mode = "440";
      inherit (config.users.users.acme) group;
      format = "binary";
    };
    coturn_static_secret = {
      mode = "440";
      inherit (config.users.users.turnserver) group;
    };
    matrix_registration_token = {
      mode = "440";
      inherit (config.services.matrix-tuwunel) group;
    };
    ceres-mautrix-discord-secrets = {
      mode = "440";
      inherit (config.users.users.mautrix-discord) group;
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
    defaults.email = "dc11eea7-ff49-42b0-b924-53f8d589931d@anonaddy.me";
    certs = {
      ${domain} = {
        dnsProvider = "cloudflare";
        environmentFile = config.sops.secrets.ceres-acme-secrets.path;
      };
      ${turn-domain} = {
        dnsProvider = "cloudflare";
        environmentFile = config.sops.secrets.ceres-acme-secrets.path;
        postRun = "systemctl restart coturn.service";
        inherit (config.users.users.turnserver) group;
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
          proxyPass = "http://[::1]:${toString port}";
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
      extraConfig = ''
        no-multicast-peers
        no-loopback-peers
        no-tcp-relay
        stale-nonce=600
        denied-peer-ip=0.0.0.0-0.255.255.255
        denied-peer-ip=10.0.0.0-10.255.255.255
        denied-peer-ip=100.64.0.0-100.127.255.255
        denied-peer-ip=127.0.0.0-127.255.255.255
        denied-peer-ip=169.254.0.0-169.254.255.255
        denied-peer-ip=172.16.0.0-172.31.255.255
        denied-peer-ip=192.0.0.0-192.0.0.255
        denied-peer-ip=192.0.2.0-192.0.2.255
        denied-peer-ip=192.88.99.0-192.88.99.255
        denied-peer-ip=192.168.0.0-192.168.255.255
        denied-peer-ip=198.18.0.0-198.19.255.255
        denied-peer-ip=198.51.100.0-198.51.100.255
        denied-peer-ip=203.0.113.0-203.0.113.255
        denied-peer-ip=224.0.0.0-239.255.255.255
        denied-peer-ip=240.0.0.0-255.255.255.255
        denied-peer-ip=::1
        denied-peer-ip=fe80::-febf:ffff:ffff:ffff:ffff:ffff:ffff:ffff
        denied-peer-ip=fc00::-fdff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
        denied-peer-ip=::ffff:0.0.0.0-::ffff:255.255.255.255
        denied-peer-ip=ff00::-ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
        denied-peer-ip=2001:db8::-2001:db8:ffff:ffff:ffff:ffff:ffff:ffff
      '';
    };
    matrix-tuwunel = {
      enable = true;
      settings.global = {
        address = ["::1"];
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
          hostname = "[::1]";
          database = {
            type = "sqlite3-fk-wal";
            uri = "file:${config.services.mautrix-discord.dataDir}/mautrix-discord.db?_txlock=immediate";
          };
        };
        homeserver = {
          inherit domain;
          address = "http://[::1]:${toString port}/";
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
