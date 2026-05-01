_: {
  flake.nixosModules.clean-store = _: {
    nix = {
      gc = {
        automatic = true;
        dates = "daily";
        options = "--delete-older-than 3d";
      };
      optimise = {
        automatic = true;
        dates = ["daily"];
      };
    };
  };
}
