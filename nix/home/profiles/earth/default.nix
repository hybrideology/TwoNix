{self, ...}: {
  flake.homeModules.earth = {pkgs, ...}: {
    imports = [
      self.homeModules.base
      self.homeModules.element-desktop
      self.homeModules.gimp
      self.homeModules.godot
      self.homeModules.home-dirs
      self.homeModules.hyprland
      self.homeModules.kitty
      self.homeModules.libresprite
      self.homeModules.librewolf
      self.homeModules.mpv
      self.homeModules.noctalia
      self.homeModules.rnote
      self.homeModules.tor-browser
      self.homeModules.vesktop
      self.homeModules.wl-clip-persist
    ];
    vars.noctalia-settings = ./noctalia-settings.json;
    home = {
      pointerCursor = {
        package = pkgs.phinger-cursors;
        name = "phinger-cursors-light";
        size = 32;
        gtk.enable = true;
      };
      packages = with pkgs; [
        noto-fonts
        nerd-fonts.symbols-only
      ];
      file = {
        ".face".source = ./face.png;
        "Pictures/Wallpapers/earth.jpg".source = ./wallpapers/earth.jpg;
      };
    };
    fonts.fontconfig.enable = true;
  };
}
