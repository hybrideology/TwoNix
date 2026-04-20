{pkgs, ...}: {
  # NOTE: Careful adding things to this file.
  # Anonymity relies on no specific configuration
  home.packages = [
    pkgs.tor-browser
  ];
}
