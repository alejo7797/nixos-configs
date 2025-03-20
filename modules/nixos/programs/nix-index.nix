{ inputs, ... }: {

  imports = [ inputs.nix-index-database.nixosModules.nix-index ];

  programs = {

    # Does not work without channels.
    command-not-found.enable = false;

    # Use community database.
    nix-index.enable = true;

  };

}
