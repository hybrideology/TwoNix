_: {
  flake.nixosModules.snowflake = _: {
    services.snowflake-proxy.enable = true;
  };
}
