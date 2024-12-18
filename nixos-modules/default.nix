{ inputs, pkgs, lib, ... }: {

  imports = [

    # External modules.
    inputs.home-manager.nixosModules.home-manager
    inputs.stylix.nixosModules.stylix

    # My personal modules.
    ./style.nix ./users.nix ./locale.nix
    ./vim.nix ./wayland.nix ./gui.nix
    ./sddm.nix ./sway.nix ./hyprland.nix
    ./dolphin.nix ./fcitx5.nix

  ];

  # Enable Nix flakes support.
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow unfree packages.
  nixpkgs.config = { allowUnfree = true; };

  # Access ilya-fedin's repository.
  nixpkgs.overlays = [
    (self: super: { ilya-fedin = import inputs.ilya-fedin { pkgs = super; }; })
  ];

  # Install and configure zsh.
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };

  # Install and configure vim.
  myNixOS.vim.enable = true;

  # Enable systemd-timesyncd.
  services.timesyncd.enable = lib.mkDefault true;

  # Use the en_DK.UTF-8 locale for dates and times.
  myNixOS.iso-time-format.enable = true;

  # Enable polkit.
  security.polkit.enable = true;

  # Install git.
  programs.git.enable = true;

  # Enable the SSH agent.
  programs.ssh.startAgent = true;

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
    bind curl file ffmpeg htop imagemagick
    libfido2 lsd neofetch nettools nmap procps
    psmisc rsync usbutils uv wget yt-dlp
  ];

}
