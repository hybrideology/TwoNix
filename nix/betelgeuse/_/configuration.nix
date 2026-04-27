{
  inputs,
  config,
  ...
}: {
  imports = [
    ./disko.nix
    ./hardware.nix
  ];
  nixpkgs.hostPlatform = "x86_64-linux";
  time.timeZone = "America/Chicago";
  networking.hostName = "betelgeuse";
  networking.hostId = "1352f34a"; # random, required by zfs
  sops.secrets.personal_vpn_key.sopsFile = inputs.secrets.betelgeuse;
  system.stateVersion = "25.11";
  home-manager.users.will.home.stateVersion = "25.11";
  vars.wireguard = {
    clientIp = "10.0.0.5";
    serverPublicKey = "QWwLEg0SjMm0ZNyb8iPa9V/29/VnHLKt9ZpVUaiE7j0=";
    endpoint = "465241395.xyz:51820";
  };
  environment.persistence.${config.vars.persistence.dir}.directories = ["/tmp"]; # low memory
  boot.tmp.cleanOnBoot = true;
}
