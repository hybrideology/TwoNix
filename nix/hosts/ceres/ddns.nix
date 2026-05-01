{inputs, ...}: {
  flake.nixosModules.ceres = {config, ...}: {
    users.groups.ddns-updater-secrets = {};
    sops.secrets.ceres-ddns-updater = {
      sopsFile = inputs.secrets.ceres-ddns-updater;
      path = "/etc/ddns-updater/config.json";
      mode = "440";
      group = config.users.groups.ddns-updater-secrets.name;
      format = "binary";
    };
    systemd.services.ddns-updater.serviceConfig.SupplementaryGroups = [
      config.users.groups.ddns-updater-secrets.name
    ];
    services.ddns-updater = {
      enable = true;
      environment = {
        SERVER_ENABLED = "no";
        PERIOD = "1m";
        CONFIG_FILEPATH = config.sops.secrets.ceres-ddns-updater.path;
      };
    };
  };
}
