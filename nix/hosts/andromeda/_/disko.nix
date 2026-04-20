{
  inputs,
  config,
  ...
}: let
  pDir = config.vars.persistence.dir;
  plaDir = config.vars.persistence.laDir;
  keyDir = "/keys";
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
        device = "/dev/disk/by-id/wwn-0x5f8db4c141803e8c";
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
      hdd = {
        type = "disk";
        device = "/dev/disk/by-id/wwn-0x50014ee20e131e19";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "tank";
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
          compression = "zstd";
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
            mountpoint = pDir;
          };
          keys = {
            type = "zfs_fs";
            mountpoint = keyDir;
          };
        };
      };
      tank = {
        type = "zpool";
        options.ashift = "12";
        rootFsOptions = {
          atime = "off";
          compression = "zstd";
          encryption = "on";
          keyformat = "passphrase";
          keylocation = "prompt";
          mountpoint = "none";
        };
        datasets = {
          persist-la = {
            type = "zfs_fs";
            mountpoint = plaDir;
          };
        };
      };
    };
  };
  fileSystems = {
    ${pDir}.neededForBoot = true;
    ${plaDir}.neededForBoot = true;
  };
}
