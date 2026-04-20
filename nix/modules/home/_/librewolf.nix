_: {
  programs.librewolf = {
    enable = true;
    policies = {
      BlockAboutConfig = true;
      BlockAboutProfiles = true;
      DisableAppUpdate = true;
      DisableSetDesktopBackround = true;
      DisableSystemAddonUpdate = true;
      ExtensionSettings = {
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          default_area = "navbar";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
          installation_mode = "force_installed";
        };
      };
      SearchEngines.Default = "DuckDuckGo Lite";
    };
    profiles.default = {
      isDefault = true;
      bookmarks = {
        force = true;
        settings = [
          {
            name = "Nix sites";
            toolbar = true;
            bookmarks = [
              {
                name = "homepage";
                url = "https://nixos.org/";
              }
              {
                name = "wiki";
                tags = ["wiki" "nix"];
                url = "https://wiki.nixos.org/";
              }
              {
                name = "search";
                url = "https://search.nixos.org/packages";
              }
              {
                name = "home-manager search";
                url = "https://home-manager-options.extranix.com/";
              }
            ];
          }
        ];
      };
      settings = {
        "browser.startup.page" = 3;
      };
    };
  };
  stylix.targets.librewolf.profileNames = ["default"];
  vars.persistence.dirs = [".librewolf"];
}
