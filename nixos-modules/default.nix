{ inputs, pkgs, lib, ... }: {

  imports = [

    # External modules.
    inputs.home-manager.nixosModules.home-manager
    inputs.stylix.nixosModules.stylix

    # My personal modules.
    ./style.nix ./users.nix ./vim.nix ./locale.nix

  ];

  # Enable Nix flakes support.
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow unfree packages.
  nixpkgs.config = { allowUnfree = true; };

  # Access ilya-fedin's repository.
  nixpkgs.overlays = [
    (self: super: { ilya-fedin = import inputs.ilya-fedin { pkgs = super; }; })
  ];

  # Enable and configure zsh.
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };

  # Enable and configure vim.
  myNixOS.vim.enable = true;

  # Enable systemd-timesyncd.
  services.timesyncd.enable = lib.mkDefault true;

  # Use the en_DK.UTF-8 locale for dates and times.
  myNixOS.iso-time-format.enable = true;

  # Enable polkit.
  security.polkit.enable = true;

  # Enable plocate.
  services.locate = {
    enable = true;
    localuser = null;
    package = pkgs.plocate;
  };

}
