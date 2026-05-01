{inputs, ...}: {
  flake.homeModules.noctalia = {
    config,
    lib,
    ...
  }: {
    options.vars.noctalia-settings = lib.mkOption {
      type = lib.types.path;
    };
    imports = [inputs.noctalia-shell.homeModules.default];
    config = {
      vars.persistence.files = [
        ".cache/noctalia/wallpapers.json"
      ];
      programs.noctalia-shell = {
        enable = true;
        settings = config.vars.noctalia-settings;
      };

      wayland.windowManager.hyprland.settings = {
        "$noctaliaIpc" = "${lib.getExe config.programs.noctalia-shell.package} ipc call";
        exec-once = [
          "uwsm app -- ${lib.getExe config.programs.noctalia-shell.package}"
        ];
        bind = [
          "$mainMod, D, exec, $noctaliaIpc launcher toggle"
          "$mainMod, u, exec, $noctaliaIpc lockScreen lock"
        ];
      };
    };
  };
}
