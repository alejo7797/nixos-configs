{
  services.resolved = {

    # No fallback DNS.
    fallbackDns = [ ];

    # Enable advanced settings.
    dnsovertls = "opportunistic";
    dnssec = "allow-downgrade";

  };
}
