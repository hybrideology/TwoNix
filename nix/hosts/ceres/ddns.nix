{
  inputs,
  config,
  ...
}: {
  sops.secrets.ceres-ddns-updater = {
    sopsFile = inputs.secrets.ceres-ddns-updater;
    path = "/etc/ddns-updater/config.json";
    mode = "444";
    format = "binary";
  };
  services.ddns-updater = {
    enable = true;
    environment = {
      SERVER_ENABLED = "no";
      PERIOD = "1m";
      CONFIG_FILEPATH = config.sops.secrets.ceres-ddns-updater.path;
    };
  };
}
