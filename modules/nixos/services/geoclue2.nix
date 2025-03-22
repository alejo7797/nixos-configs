{
  services.geoclue2 = {

    # See: https://github.com/NixOS/nixpkgs/issues/321121.
    geoProviderUrl = "https://api.beacondb.net/v1/geolocate";

  };
}
