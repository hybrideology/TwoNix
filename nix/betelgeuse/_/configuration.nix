{config, ...}: {
  imports = [
    ./disko.nix
    ./hardware.nix
  ];
  time.timeZone = "America/Chicago";
  networking.hostName = "betelgeuse";
  networking.hostId = "1352f34a"; # random, required by zfs
  system.stateVersion = "25.11";
  vars.wireguard.clientIp = "10.0.0.5";
  environment.persistence.${config.vars.persistence.dir}.directories = ["/tmp"]; # low memory
  boot.tmp.cleanOnBoot = true;
}
