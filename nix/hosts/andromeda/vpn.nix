{
  inputs,
  config,
  ...
}: {
  sops.secrets.personal_vpn_key = {
    sopsFile = inputs.secrets.andromeda;
    mode = "440";
    owner = config.users.users.systemd-network.name;
    inherit (config.users.users.systemd-network) group;
  };
  networking.useNetworkd = true;
  systemd.network = {
    enable = true;
    networks = {
      "50-wg0" = {
        matchConfig.Name = "wg0";
        address = ["10.0.0.2/24"];
        dns = ["10.0.0.1"];
      };
    };
    netdevs = {
      "50-wg0" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = "wg0";
        };
        wireguardConfig = {
          PrivateKeyFile = config.sops.secrets.personal_vpn_key.path;
          RouteTable = "main";
        };
        wireguardPeers = [
          {
            PublicKey = "QWwLEg0SjMm0ZNyb8iPa9V/29/VnHLKt9ZpVUaiE7j0=";
            AllowedIPs = [
              "10.0.0.0/24"
            ];
            Endpoint = "465241395.xyz:51820";
          }
        ];
      };
    };
  };
}
