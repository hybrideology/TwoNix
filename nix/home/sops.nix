{inputs, ...}: {
  flake.homeModules.sops = {
    pkgs,
    config,
    ...
  }: {
    imports = [inputs.sops-nix.homeManagerModules.sops];
    home.packages = [pkgs.sops];
    sops.age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
    vars.persistence.dirs = [
      {
        directory = ".config/sops";
        mode = "0700";
      }
    ];
  };
}
