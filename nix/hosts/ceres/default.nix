{
  inputs,
  config,
  ...
}: {
  flake.modules.nixos.ceres = {
    imports = [
      config.flake.modules.nixos.server
      config.flake.modules.nixos.will
      config.flake.modules.nixos.nixarr
      {
        sops.secrets = {
          personal_vpn_key.sopsFile = inputs.secrets.ceres;
          vpn_proxy_conf.sopsFile = inputs.secrets.ceres-vpn-proxy;
          ceres-ddns-updater.sopsFile = inputs.secrets.ceres-ddns-updater;
          ceres-acme-secrets.sopsFile = inputs.secrets.ceres-acme-secrets;
          coturn_static_secret.sopsFile = inputs.secrets.ceres;
          matrix_registration_token.sopsFile = inputs.secrets.ceres;
          ceres-mautrix-discord-secrets.sopsFile = inputs.secrets.ceres-mautrix-discord-secrets;
        };
      }
      {
        home-manager.users.will.imports = [config.flake.homeModules.desolate];
        home-manager.users.will.home.stateVersion = "25.11";
      }
      ./_/configuration.nix
    ];
  };

  configurations.nixos.ceres = {
    module = config.flake.modules.nixos.ceres;
    nixpkgsInput = "nixpkgs-small";
  };
}
