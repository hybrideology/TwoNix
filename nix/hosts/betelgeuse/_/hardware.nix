_: {
  services.xserver.videoDrivers = [
    "modesetting"
  ];
  hardware = {
    facter.reportPath = ./facter.json;
    nvidia = {
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        intelBusId = "PCI:1@0:0:0";
        nvidiaBusId = "PCI:2@0:0:0";
      };
    };
  };
}
