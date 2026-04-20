{
  inputs,
  config,
  ...
}: let
  pdir = config.vars.persistence.dir;
  pladir = config.vars.persistence.laDir;
in {
  imports = [inputs.disko.nixosModules.disko];
  vars.persistence.enable = true;

  disko.devices = {
    nodev = {
      "/" = {
        fsType = "tmpfs";
        mountOptions = ["size=50%" "mode=755" "noatime"];
      };
    };
    disk = {
      ssd = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-eui.002538b121c63cc2";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["umask=0077"];
              };
            };
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "fast";
              };
            };
          };
        };
      };
    };
    zpool = {
      fast = {
        type = "zpool";
        options = {
          ashift = "12";
          autotrim = "on";
        };
        rootFsOptions = {
          atime = "off";
          compression = "lz4";
          encryption = "on";
          keyformat = "passphrase";
          keylocation = "prompt";
          mountpoint = "none";
        };
        datasets = {
          nix = {
            type = "zfs_fs";
            mountpoint = "/nix";
          };
          persist = {
            type = "zfs_fs";
            mountpoint = pdir;
          };
          persist-la = {
            type = "zfs_fs";
            mountpoint = pladir;
          };
        };
      };
    };
  };
  fileSystems = {
    ${pdir}.neededForBoot = true;
    ${pladir}.neededForBoot = true;
  };
}
