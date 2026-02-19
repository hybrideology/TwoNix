{config, ...}: {
  sops.secrets."wpa_secrets" = {
    owner = config.users.users.wpa_supplicant.name;
    inherit (config.users.users.wpa_supplicant) group;
  };
  networking.wireless = {
    enable = true;
    secretsFile = config.sops.secrets."wpa_secrets".path;
    networks = {
      "greenlee2".pskRaw = "ext:psk_greenlee2";
      "stronghold".pskRaw = "ext:psk_stronghold";
      "LCA Guest".pskRaw = "ext:psk_lca_guest";
      "fallback".ssid = ""; # connect to any open network (risky but whatevs)
    };
  };
}
