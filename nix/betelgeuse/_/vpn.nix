{inputs, ...}: {
  sops.secrets.personal_vpn_key.sopsFile = inputs.secrets.betelgeuse;
  vars.wireguard = {
    clientIp = "10.0.0.5";
    serverPublicKey = "QWwLEg0SjMm0ZNyb8iPa9V/29/VnHLKt9ZpVUaiE7j0=";
    endpoint = "465241395.xyz:51820";
  };
}
