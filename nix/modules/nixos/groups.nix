_: {
  flake.modules.nixos.groups = _: {
    users.groups.users.gid = 100; # required for migration script
  };
}
