{config, ...}: {
  imports = [
    ./disko.nix
    ./hardware.nix
    ./users.nix
    ./vpn.nix
  ];
  time.timeZone = "America/Chicago";
  networking.hostName = "betelgeuse";
  networking.hostId = "1352f34a"; # random, required by zfs
  system.stateVersion = "25.11";
  environment.persistence.${config.vars.persistence.dir}.directories = ["/tmp"]; # low memory
  boot.tmp.cleanOnBoot = true;
}
