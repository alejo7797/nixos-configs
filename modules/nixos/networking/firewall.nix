{
  networking.firewall = {

    # Avoid Wireguard issues.
    checkReversePath = false;

    # Reduce kernel log verbosity.
    logRefusedConnections = false;

  };
}
