{inputs, ...}: {
  flake.homeModules.will = {
    imports = [
      inputs.sops-nix.homeManagerModules.sops
      ../_/will.nix
    ];
    sops.defaultSopsFile = inputs.secrets.will;
  };
}
