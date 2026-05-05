_: {
  flake.nixosModules.bash = _: {
    vars.persistence.homeFiles = [".bash_history"];
  };
}
