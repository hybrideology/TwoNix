_: {
  flake.modules.nixos.snowflake = _: {
    services.snowflake-proxy.enable = true;
  };
}
