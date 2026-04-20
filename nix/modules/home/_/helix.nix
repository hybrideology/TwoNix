{
  lib,
  pkgs,
  ...
}: {
  home.packages = [
    pkgs.nil
    pkgs.nixd
  ];
  programs.helix = {
    enable = true;
    defaultEditor = true;
    languages.language = [
      {
        name = "nix";
        auto-format = true;
        formatter.command = lib.getExe pkgs.alejandra;
      }
    ];
  };
}
