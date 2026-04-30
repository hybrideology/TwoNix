_: {
  flake.modules.nixos.ceres = {inputs, ...}: {
    imports = [inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate];
    hardware.facter.reportPath = ./facter.json;
  };
}
