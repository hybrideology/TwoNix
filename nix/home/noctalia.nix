{self, ...}: {
  flake.homeModules.noctalia = {
    lib,
    pkgs,
    ...
  }: let
    pkg = self.packages.${pkgs.stdenv.hostPlatform.system}.noctalia-shell;
  in {
    config = {
      vars.persistence.files = [
        ".cache/noctalia/wallpapers.json"
      ];
      wayland.windowManager.hyprland.settings = {
        "$noctaliaIpc" = "${lib.getExe pkg} ipc call";
        exec-once = [
          "uwsm app -- ${lib.getExe pkg}"
        ];
        bind = [
          "$mainMod, D, exec, $noctaliaIpc launcher toggle"
          "$mainMod, u, exec, $noctaliaIpc lockScreen lock"
        ];
      };
    };
  };
}
