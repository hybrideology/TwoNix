{
  config,
  pkgs,
  ...
}: {
  programs.hyprshot = {
    enable = true;
    saveLocation = "${config.home.homeDirectory}/Pictures/hyprshot";
  };
  home.packages = [
    pkgs.satty
  ];
}
