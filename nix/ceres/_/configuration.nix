{inputs, ...}: {
  imports = [
    ./disko.nix
    ./ddns.nix
    ./hardware.nix
    ./matrix-server.nix
    ./media-server.nix
    ./nginx.nix
    ./vars.nix
    ./vpn.nix
  ];
  nixpkgs.hostPlatform = "x86_64-linux";
  time.timeZone = "America/Chicago";
  networking.hostName = "ceres";
  networking.hostId = "e0fdcfa7"; # random, required by zfs
  sops.secrets = {
    personal_vpn_key.sopsFile = inputs.secrets.ceres;
    vpn_proxy_conf.sopsFile = inputs.secrets.ceres-vpn-proxy;
    ceres-ddns-updater.sopsFile = inputs.secrets.ceres-ddns-updater;
    ceres-acme-secrets.sopsFile = inputs.secrets.ceres-acme-secrets;
    coturn_static_secret.sopsFile = inputs.secrets.ceres;
    matrix_registration_token.sopsFile = inputs.secrets.ceres;
    ceres-mautrix-discord-secrets.sopsFile = inputs.secrets.ceres-mautrix-discord-secrets;
  };
  system.stateVersion = "25.11";
  home-manager.users.will.home.stateVersion = "25.11";
}
