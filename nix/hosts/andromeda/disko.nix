_: {
  flake.nixosModules.andromeda = {
    config,
    lib,
    ...
  }: let
    pDir = config.vars.persistence.dir;
    plaDir = config.vars.persistence.laDir;
    keyDir = "/keys";
    keyUUID = "AF7B-D7D2";
  in {
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
            keyformat = "raw";
            keylocation = "file://${keyDir}/fast";
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
            keyformat = "raw";
            keylocation = "file://${keyDir}/tank";
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
    boot = {
      initrd = {
        kernelModules = ["usb_storage" "usbcore" "uas"];
        supportedFilesystems.vfat = true;
        systemd = {
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
      ${pDir}.neededForBoot = true;
      ${plaDir}.neededForBoot = true;
    };
  };
}
