{
  osConfig,
  pkgs,
  ...
}: {
  programs.lutris = {
    enable = true;
    protonPackages = [pkgs.proton-ge-bin];
    steamPackage = osConfig.programs.steam.package;
    winePackages = [pkgs.wineWowPackages.waylandFull];
  };
  vars.persistence.dirs = [".local/share/lutris"];
}
