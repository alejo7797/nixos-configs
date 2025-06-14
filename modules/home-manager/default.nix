{ inputs, lib, ... }: {

  imports = with lib.fileset;

    # Import any external Home Manager modules.
    [ inputs.sops-nix.homeManagerModules.sops ]

    ++

    toList (difference
      # Automatically import Home Manager modules.
      (fileFilter (file: file.hasExt "nix") ./.)
      ./default.nix # You cannot import yourself!
    )

  ;

  nix.gc = {
    automatic = true; frequency = "daily";
    options = "--delete-older-than 7d";
  };

}
