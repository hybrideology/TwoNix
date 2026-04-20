_: {
  system.autoUpgrade = {
    enable = true;
    flake = "github:hybrideology/TwoNix";
    flags = ["-L"];
    dates = "04:00";
    randomizedDelaySec = "45min";
    persistent = true;
    allowReboot = true;
    rebootWindow = {
      lower = "02:00";
      upper = "05:00";
    };
  };
}
