{ inputs, ... }: {

  # My personal Home Manager modules.
  imports = [ ./style.nix ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

}
