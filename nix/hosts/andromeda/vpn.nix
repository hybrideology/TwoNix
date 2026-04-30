_: {
  flake.modules.nixos.andromeda = {inputs, ...}: {
    sops.secrets.personal_vpn_key.sopsFile = inputs.secrets.andromeda;
    vars.wireguard = {
      clientIp = "10.0.0.2";
      serverPublicKey = "QWwLEg0SjMm0ZNyb8iPa9V/29/VnHLKt9ZpVUaiE7j0=";
      endpoint = "465241395.xyz:51820";
    };
  };
}
