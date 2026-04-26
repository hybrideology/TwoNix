{inputs, ...}: {
  flake.modules.nixos.sops = _: {
    imports = [inputs.sops-nix.nixosModules.sops];
    sops.defaultSopsFile = inputs.secrets.secrets;
  };
}
