{ pkgs, lib, config,  ... }: {

  # Did you read the comment?
  system.stateVersion = "24.11";

  # Set the system architecure.
  nixpkgs.hostPlatform.system = "x86_64-linux";

  # QEMU guest settings.
  virtualisation.qemu.options = [ "-device virtio-vga" ];

  # Set the hostname.
  networking.hostName = "nixos-vm";

  # Configure my user account.
  myNixOS.home-users."ewan" = {
    userConfig = ./home.nix;
    userSettings = {
      description = "Alex";
    };
  };

  # Enable my custom system theme.
  myNixOS.style.enable = true;

  # Use systemd-boot as our boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Set the kernel parameters.
  boot.kernelParams = [ "quiet" "splash" "loglevel=3" "nowatchdog" ];

  # Use NetworkManager together with systemd-resolved.
  networking.networkmanager.enable = true;
  services.resolved.enable = true;

  # Set the system time zone.
  time.timeZone = "Europe/Madrid";

  # Customise the tty.
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Use tuigreet to log us in.
  myNixOS.tuigreet.enable = true;

  # Install sway, the i3-compatible Wayland compositor.
  myNixOS.sway.enable = true;

  # Install Hyprland, the tiling Wayland compositor.
  myNixOS.hyprland.enable = true;

  # Enable sound support.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Configure Fcitx5 as our input method.
  myNixOS.fcitx5.enable = true;

  # Enable printing-related services.
  services.printing.enable = true;
  services.avahi.enable = true;
  services.saned.enable = true;
  services.system-config-printer.enable = true;

  # Enable and configure syncthing.
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
  };

  # Install Dolphin and related KDE applications.
  myNixOS.dolphin.enable = true;

  # Install Thunderbird.
  programs.thunderbird.enable = true;

  # Install Wireshark.
  programs.wireshark.enable = true;

  # Install Steam and Protontricks.
  programs.steam = {
    enable = true;
    protontricks.enable = true;
  };

  # Install gamemode.
  programs.gamemode.enable = true;

  # Install the following packages system-wide.
  environment.systemPackages = with pkgs; [

    # Hardware support.
    cnijfilter2 ntfs3g

    # Actual programs.
    filezilla gimp inkscape
    joplin-desktop plex-desktop
    qbittorrent spotify
    ungoogled-chromium
    variety yubioath-flutter
    zathura zoom-us zotero

    # Wine.
    wineWowPackages.stable
    winetricks

    # Gaming.
    gamescope lutris
    prismlauncher vesktop

    # Coding.
    biber black clang
    gdb jupyter
    #mathematica-webdoc
    nixfmt-rfc-style
    ruby sage
    shellcheck shfmt

    # LaTeX.
    (texlive.combine {
      inherit (texlive)
        scheme-medium
        collection-langcyrillic
        ;
    })

  ];

}
