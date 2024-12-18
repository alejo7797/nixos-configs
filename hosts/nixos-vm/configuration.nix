{ inputs, outputs, lib, myLib, pkgs, config,  ... }: {

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

  # Use systemd-boot as the boot loader.
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

  # Enable and configure SDDM.
  services.xserver.enable = true;
  services.displayManager = {
    defaultSession = "sway";
    sddm = {
      enable = true;
      theme = "chili";
      settings = {
        Current = {
          CursorSize = 24;
          CursorTheme = "breeze_cursors";
        };
      };
    };
  };

  # Enable sway.
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = [ ];
  };

  # Enable Hyprland.
  programs.hyprland.enable = true;

  # Enable sound.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable polkit.
  security.polkit.enable = true;

  # And give us easy access to the gnome polkit agent.
  systemd.user.units."polkit-gnome-agent.service" = {
    text = ''
      [Unit]
      Description=GNOME polkit agent

      [Service]
      Type=oneshot
      ExecStart=${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1
    '';
  };

  # Enable and configure fcitx5.
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      plasma6Support = true;
      addons = with pkgs; [
        fcitx5-mozc
        fcitx5-rime
      ];
    };
  };

  # And define the following environment variables.
  environment.variables = {
    SDL_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
  };

  # Enable printer-related services.
  services.printing.enable = true;
  services.avahi.enable = true;
  services.saned.enable = true;
  services.system-config-printer.enable = true;

  # Enable and configure syncthing.
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
  };

  # Enable and configure the GnuPG agent.
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gnome3;
  };

  # Manage storage devices.
  services.udisks2.enable = true;
  programs.gnome-disks.enable = true;

  # More useful utilities to enable.
  services.blueman.enable = true;
  programs.dconf.enable = true;
  programs.direnv.enable = true;
  services.geoclue2.enable = true;
  programs.git.enable = true;
  programs.gamemode.enable = true;
  programs.kdeconnect.enable = true;
  programs.nm-applet.enable = true;
  programs.ssh.startAgent = true;

  # Install firefox and set it as default.
  programs.firefox.enable = true;
  environment.variables.BROWSER = "firefox";

  # More programs benefitting from system integration.
  programs.thunderbird.enable = true;
  programs.wireshark.enable = true;

  # Install Steam to download and play games.
  programs.steam = {
    enable = true;
    protontricks.enable = true;
  };

  # Install the following packages system-wide.
  environment.systemPackages = with pkgs; [

    # Hardware support.
    cnijfilter2
    ntfs3g

    # Utilities.
    bemenu
    bind
    curl
    dex
    file
    ffmpeg
    htop
    imagemagick
    libfido2
    lsd
    neofetch
    nettools
    nmap
    pdftk
    playerctl
    psmisc
    rsync
    usbutils
    wget
    yt-dlp

    # Wayland goodies.
    brightnessctl
    gammastep
    hyprlock
    kanshi
    swaybg
    swayidle
    swaynotificationcenter
    waybar
    wf-recorder
    wofi
    wl-clipboard
    wlogout

    # KDE and QT utilities.
    kdePackages.ark
    libsForQt5.breeze-qt5
    kdePackages.breeze
    kdePackages.dolphin
    kdePackages.dolphin-plugins
    kdePackages.ffmpegthumbs
    kdePackages.gwenview
    kdePackages.kimageformats
    kdePackages.kio-admin
    kdePackages.kio-extras
    kdePackages.konsole
    kdePackages.qtsvg
    libsForQt5.qt5.qtwayland
    kdePackages.qtwayland
    ilya-fedin.qt5ct
    ilya-fedin.qt6ct

    # Other GUI utilities.
    dconf-editor
    font-manager
    pavucontrol
    xsettingsd

    # Actual programs.
    filezilla
    gimp
    inkscape
    joplin-desktop
    keepassxc
    kitty
    libreoffice
    mpv
    #plex-desktop
    qbittorrent
    #spotify
    ungoogled-chromium
    variety
    yubioath-flutter
    zathura
    zoom-us
    zotero

    # Wine.
    wineWowPackages.stable
    winetricks

    # Gaming.
    gamescope
    lutris
    prismlauncher
    vesktop

    # Coding.
    biber
    black
    clang
    gdb
    jupyter
    #mathematica-webdoc
    nixfmt-rfc-style
    ruby
    sage
    shellcheck
    shfmt
    uv

    # TeX Live.
    (texlive.combine {
      inherit (texlive)
        scheme-medium
        collection-langcyrillic
        ;
    })

    # SDDM theme.
    (sddm-chili-theme.override {
      themeConfig = {
        ScreenWidth = 960;
      };
    })

  ];

  # This fixes the unpopulated MIME menus.
  environment.etc."/xdg/menus/plasma-applications.menu".text =
    builtins.readFile "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
  environment.variables.XDG_MENU_PREFIX = "plasma-";

  # Install the following fonts system-wide.
  fonts.packages = with pkgs; [
    #corefonts
    dejavu_fonts
    font-awesome
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    source-han-sans
    source-han-serif
    source-sans
  ];

}
