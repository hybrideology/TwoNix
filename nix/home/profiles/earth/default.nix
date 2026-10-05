{self, ...}: {
  flake.homeModules.earth = {pkgs, ...}: {
    imports = [
      self.homeModules.base
      self.homeModules.gimp
      self.homeModules.home-dirs
      self.homeModules.libresprite
      self.homeModules.librewolf
      self.homeModules.mpv
      self.homeModules.signal
      self.homeModules.tor-browser
      self.homeModules.udiskie
      self.homeModules.vesktop
    ];
    home = {
      pointerCursor = {
        enable = true;
        package = pkgs.phinger-cursors;
        name = "phinger-cursors-light";
        size = 32;
        gtk.enable = true;
      };
      packages = with pkgs; [
        noto-fonts
        nerd-fonts.symbols-only
      ];
      file."Pictures/Wallpapers/earth.jpg".source = ./wallpapers/earth.jpg;
    };
    fonts.fontconfig.enable = true;
    gtk = {
      enable = true;
      iconTheme = {
        package = pkgs.adwaita-icon-theme;
        name = "Adwaita";
      };
    };
    qt = {
      enable = true;
      platformTheme.name = "gtk3";
    };
  };
}
