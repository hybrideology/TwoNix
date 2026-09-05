{inputs, ...}: {
  perSystem = {
    pkgs,
    lib,
    self',
    ...
  }: {
    packages.niri = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;
      settings = {
        spawn-at-startup = [
          (lib.getExe self'.packages.noctalia-shell)
        ];

        xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

        input.keyboard.xkb.layout = "us";

        layout.gaps = 5;

        binds = {
          "Mod+Q".spawn-sh = lib.getExe pkgs.kitty;
          "Mod+C".close-window = {};
          "Mod+D".spawn-sh = "${lib.getExe self'.packages.noctalia-shell} ipc call launcher toggle";
        };
      };
    };
  };
}
