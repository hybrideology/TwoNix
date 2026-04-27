{
  inputs,
  config,
  ...
}: {
  flake.homeModules.earth = {
    imports = [
      inputs.noctalia-shell.homeModules.default
      ./_/files.nix
      config.flake.homeModules.hyprland
      config.flake.homeModules.vars
      config.flake.homeModules.btop
      config.flake.homeModules.element-desktop
      config.flake.homeModules.gimp
      config.flake.homeModules.godot
      config.flake.homeModules.helix
      config.flake.homeModules.homeDirs
      config.flake.homeModules.jujutsu
      config.flake.homeModules.kitty
      config.flake.homeModules.libresprite
      config.flake.homeModules.librewolf
      config.flake.homeModules.mpv
      config.flake.homeModules.nh
      config.flake.homeModules.nixos-anywhere
      ./_/noctalia.nix
      config.flake.homeModules.rnote
      config.flake.homeModules.ssh
      config.flake.homeModules.starship
      config.flake.homeModules.tor-browser
      config.flake.homeModules.unar
      config.flake.homeModules.vesktop
      config.flake.homeModules.wireguard-tools
      config.flake.homeModules.wl-clip-persist
      config.flake.homeModules.yazi
      config.flake.homeModules.zsh
    ];
    programs.kitty.settings.shell = "zsh";
  };
}
