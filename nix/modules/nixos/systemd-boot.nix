_: {
  flake.modules.nixos.systemd-boot = _: {
    boot.loader.systemd-boot = {
      enable = true;
      editor = false;
      memtest86.enable = true;
      configurationLimit = 15;
    };
  };
}
