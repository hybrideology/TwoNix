{inputs, ...}: {
  perSystem = {
    pkgs,
    self',
    lib,
    ...
  }: {
    packages.nushell = inputs.wrapper-modules.wrappers.nushell.wrap {
      inherit pkgs;
      "env.nu".content = ''
        $env.EDITOR = "${lib.getExe self'.packages.helix}"
      '';
      "config.nu".content = ''
        def --env y [...args] {
         let tmp = (mktemp -t "yazi-cwd.XXXXXX")
         ^"${lib.getExe self'.packages.yazi}" ...$args --cwd-file $tmp
         let cwd = (open $tmp)
         if $cwd != $env.PWD and ($cwd | path exists) {
          cd $cwd
         }
         rm -fp $tmp
        }
        $env.config.show_banner = false
      '';
    };
  };
}
