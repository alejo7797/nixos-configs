{ inputs, pkgs, lib, ... }: {

  imports = [
    # External modules.
    inputs.home-manager.nixosModules.home-manager
    inputs.nur.modules.nixos.default
    inputs.stylix.nixosModules.stylix

    # My personal modules.
    ./users.nix ./pam.nix ./locale.nix
    ./tuigreet.nix ./programs ./nvidia.nix
    ./wayland ./graphical.nix ./style.nix
  ];

  # Enable Nix flakes support.
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow unfree packages.
  nixpkgs.config.allowUnfree = true;

  # Access ilya-fedin's repository.
  nixpkgs.overlays = [
    (self: super: { ilya-fedin = import inputs.ilya-fedin { pkgs = super; }; })
  ];

  # Limit the number of generations to keep in the bootloader.
  boot.loader.systemd-boot.configurationLimit = 20;

  # Default networking configuration.
  networking = {
    # Use standard network interface names.
    usePredictableInterfaceNames = lib.mkDefault false;

    # Wireguard trips up rpfilter.
    firewall.checkReversePath = false;
  };

  # Install and configure zsh.
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };

  # For zsh completion.
  environment.pathsToLink = [ "/share/zsh" ];

  # Install vim.
  myNixOS.vim.enable = true;

  # Install neovim.
  programs.neovim.enable = true;

  # Enable systemd-timesyncd.
  services.timesyncd.enable = lib.mkDefault true;

  # Enable polkit.
  security.polkit.enable = true;

  # Install Git.
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
  };

  # Install direnv.
  programs.direnv.enable = true;

  # Install plocate.
  services.locate = {
    enable = true;
    localuser = null;
    package = pkgs.plocate;
  };

  # Install the following essential packages.
  environment.systemPackages = with pkgs; [
    curl dig file findutils
    ffmpeg htop imagemagick
    jq libfido2 lm_sensors
    lsd  neofetch nettools
    nmap procps p7zip psmisc
    rsync unrar-free usbutils uv
    wireguard-tools wget yt-dlp
  ];

}
