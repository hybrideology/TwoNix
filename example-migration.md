# STEPS:

1. Construct extra files $temp dir (including new AGE key where applicable)
2. Construct USB with disk encryption key where applicable
3. Re-encrypt sops secrets with new AGE keys
4. Boot target system with starter image

```
nixos-anywhere
  -f .#<hostname>
  --target-host root@<host-ip>
  --generate-hardware-config nixos-facter ./nix/<hostname>/_/facter.json
  --extra-files $temp
  --disk-encryption-keys /mnt/usb/key /mnt/usb/key
  --chown /nix/persist/home/will 1000:100
```
