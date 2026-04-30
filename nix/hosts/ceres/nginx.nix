_: {
  flake.modules.nixos.ceres = _: {
    services.nginx = {
      recommendedProxySettings = true;
      recommendedBrotliSettings = true;
      recommendedOptimisation = true;
      recommendedTlsSettings = true;
    };
  };
}
