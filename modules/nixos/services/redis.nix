{ pkgs, ... }: {

  services.redis = {

    # Open source drop-in.
    package = pkgs.valkey;

  };
}
