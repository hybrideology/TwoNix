{
  inputs,
  config,
  lib,
  ...
}: let
  pdir = config.vars.persistence.dir;
  pladir = config.vars.persistence.laDir;
  mediaDir = config.vars.dataDirs.media;
  archiveDir = config.vars.dataDirs.archive;
  dbDir = config.vars.dataDirs.db;
  appsDir = config.vars.dataDirs.apps;
  keyDir = "/keys";
  keyUUID = "6A71-D31C";
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
      sata0 = {
        type = "disk";
        device = "/dev/disk/by-id/wwn-0x5001b448bc4b89f6";
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
                pool = "small";
              };
            };
          };
        };
      };
      nvme0 = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-eui.002538571190c7df";
        content = {
          type = "gpt";
          partitions.zfs = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "fast";
            };
          };
        };
      };
      nvme1 = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-eui.002538571190dbd2";
        content = {
          type = "gpt";
          partitions.zfs = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "fast";
            };
          };
        };
      };
      nvme2 = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-eui.00253857119153a0";
        content = {
          type = "gpt";
          partitions.zfs = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "fast";
            };
          };
        };
      };
      nvme3 = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-eui.0025385711918e19";
        content = {
          type = "gpt";
          partitions.zfs = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "fast";
            };
          };
        };
      };
      sata1 = {
        type = "disk";
        device = "/dev/disk/by-id/wwn-0x5000cca273c5b1a1";
        content = {
          type = "gpt";
          partitions.zfs = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "tank";
            };
          };
        };
      };
      sata2 = {
        type = "disk";
        device = "/dev/disk/by-id/wwn-0x5000cca273c94561";
        content = {
          type = "gpt";
          partitions.zfs = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "tank";
            };
          };
        };
      };
    };
    zpool = {
      small = {
        type = "zpool";
        options = {
          ashift = "12";
          autotrim = "on";
        };
        rootFsOptions = {
          atime = "off";
          compression = "zstd";
          mountpoint = "none";
        };
        datasets.nix = {
          type = "zfs_fs";
          mountpoint = "/nix";
        };
      };
      tank = {
        type = "zpool";
        mode = {
          topology = {
            type = "topology";
            vdev = [
              {
                mode = "mirror";
                members = [
                  "sata1"
                  "sata2"
                ];
              }
            ];
          };
        };
        options.ashift = "12";
        rootFsOptions = {
          atime = "off";
          compression = "zstd";
          encryption = "on";
          keyformat = "raw";
          keylocation = "file://${keyDir}/tank";
          recordsize = "1M";
          mountpoint = "none";
        };
        datasets = {
          persist-la = {
            type = "zfs_fs";
            mountpoint = pladir;
          };
          media = {
            type = "zfs_fs";
            mountpoint = mediaDir;
          };
          archive = {
            type = "zfs_fs";
            mountpoint = archiveDir;
          };
        };
      };
      fast = {
        type = "zpool";
        mode = {
          topology = {
            type = "topology";
            vdev = [
              {
                mode = "mirror";
                members = [
                  "nvme0"
                  "nvme1"
                ];
              }
              {
                mode = "mirror";
                members = [
                  "nvme2"
                  "nvme3"
                ];
              }
            ];
          };
        };
        options = {
          ashift = "12";
          autotrim = "on";
        };
        rootFsOptions = {
          atime = "off";
          compression = "zstd";
          encryption = "on";
          keyformat = "raw";
          keylocation = "file://${keyDir}/fast";
          mountpoint = "none";
        };
        datasets = {
          persist = {
            type = "zfs_fs";
            mountpoint = pdir;
          };
          db = {
            type = "zfs_fs";
            mountpoint = dbDir;
            options.recordsize = "16K";
          };
          apps = {
            type = "zfs_fs";
            mountpoint = appsDir;
          };
        };
      };
    };
  };
  boot = {
    zfs.forceImportRoot = false; # docs say to disable for better security
    initrd = {
      kernelModules = ["usb_storage" "usbcore" "uas"];
      supportedFilesystems.vfat = true;
      systemd = {
        enable = true;
        mounts = let
          importServices = lib.map (pool: "zfs-import-${pool}.service") (lib.attrNames config.disko.devices.zpool);
        in [
          {
            where = keyDir;
            what = "UUID=${keyUUID}";
            after = ["systemd-udev-settle.service"];
            wants = ["systemd-udev-settle.service"];
            before = importServices;
            requiredBy = importServices;
            options = "ro";
            type = "vfat";
          }
        ];
      };
    };
  };
  fileSystems = {
    ${pdir}.neededForBoot = true;
    ${pladir}.neededForBoot = true;
  };
}
