{inputs, ...}: {
  flake.homeModules.noctalia = {
    config,
    lib,
    ...
  }: {
    imports = [inputs.noctalia.homeModules.default];
    config = {
      vars.persistence.files = [
        ".cache/noctalia/wallpapers.json"
      ];
      programs.noctalia.enable = true;

      wayland.windowManager.hyprland.settings = {
        "$noctaliaIpc" = "${lib.getExe config.programs.noctalia.package} ipc call";
        exec-once = [
          "uwsm app -- ${lib.getExe config.programs.noctalia.package}"
        ];
        bind = [
          "$mainMod, D, exec, $noctaliaIpc launcher toggle"
          "$mainMod, u, exec, $noctaliaIpc lockScreen lock"
        ];
      };
    };
  };
}
