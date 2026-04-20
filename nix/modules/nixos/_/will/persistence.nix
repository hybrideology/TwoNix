{
  config,
  lib,
  ...
}: let
  cfg = config.vars.persistence;
  username = "will";
  hasHM =
    lib.hasAttr "home-manager" config
    && lib.hasAttr username config.home-manager.users;
  hmCfg = config.home-manager.users.will.vars.persistence;
in {
  environment.persistence = lib.mkMerge [
    {
      ${cfg.laDir}.users.${username} = {
        directories = lib.optionals config.programs.steam.enable [
          ".local/share/Steam"
          ".steam"
        ];
      };
      ${cfg.dir}.users.${username} = {
        files = lib.optional config.programs.bash.enable ".bash_history";
        directories =
          lib.optional config.programs.uwsm.enable ".config/uwsm"
          ++ lib.optional (config.services.pipewire.enable && config.services.pipewire.pulse.enable) ".config/pulse";
      };
    }
    (lib.mkIf hasHM
      {
        ${cfg.laDir}.users.${username} = {
          files = hmCfg.laFiles;
          directories = hmCfg.laDirs;
        };
        ${cfg.dir}.users.${username} = {
          inherit (hmCfg) files;
          directories = hmCfg.dirs;
        };
      })
  ];
}
