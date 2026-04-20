{
  inputs,
  pkgs,
  ...
}: {
  imports = [inputs.sops-nix.homeManagerModules.sops];
  home.packages = [pkgs.sops];
  vars.persistence.dirs = [
    {
      directory = ".config/sops";
      mode = "0700";
    }
  ];
}
