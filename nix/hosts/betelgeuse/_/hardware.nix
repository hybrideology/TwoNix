{inputs, ...}: {
  imports = [inputs.nixos-hardware.nixosModules.common-gpu-intel];
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
        intelBusId = "PCI:0@0:2:0";
        nvidiaBusId = "PCI:1@0:0:0";
      };
    };
  };
}
