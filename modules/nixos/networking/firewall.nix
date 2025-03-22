{
  networking.firewall = {

    # Issues with Wireguard.
    checkReversePath = false;

    # Reduce kernel log verbosity.
    logRefusedConnections = false;

  };
}
