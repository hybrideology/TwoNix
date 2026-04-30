{
  inputs,
  config,
  ...
}: {
  flake.homeModules.earth = {
    imports = [
      config.flake.homeModules.base
      inputs.noctalia-shell.homeModules.default
      config.flake.homeModules.element-desktop
      config.flake.homeModules.gimp
      config.flake.homeModules.godot
      config.flake.homeModules.home-dirs
      config.flake.homeModules.hyprland
      config.flake.homeModules.kitty
      config.flake.homeModules.libresprite
      config.flake.homeModules.librewolf
      config.flake.homeModules.mpv
      config.flake.homeModules.rnote
      config.flake.homeModules.tor-browser
      config.flake.homeModules.vesktop
      config.flake.homeModules.wl-clip-persist
    ];
  };
}
