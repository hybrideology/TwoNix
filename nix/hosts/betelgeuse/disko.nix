_: {
  flake.nixosModules.betelgeuse = {
    config,
    lib,
    ...
  }: let
    pDir = config.vars.persistence.dir;
    keyDir = "/keys";
    keyUUID = "3B99-042E";
  in {
    vars.persistence.enable = true;
    vars.persistence.laDir = config.vars.persistence.dir;

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
    fileSystems.${pDir}.neededForBoot = true;
    vars.persistence.dirs = [
      {
        directory = "/tmp";
        mode = "1777";
      }
    ]; # low memory
    boot.tmp.cleanOnBoot = true;
  };
}
