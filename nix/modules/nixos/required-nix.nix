_: {
  flake.modules.nixos.nix = _: {
    nix = {
      channel.enable = false;
      settings = {
        experimental-features = ["nix-command" "flakes"];
        flake-registry = ""; # Disable global flake registry
        substituters = [
          "https://cache.nixos.org/"
          "https://noctalia.cachix.org"
        ];
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
        ];
      };
    };
  };
}
