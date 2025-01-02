{ pkgs, lib, config,  ... }: {

  # Did you read the comment?
  system.stateVersion = "24.11";

  # Include hardware configuration.
  imports = [ ./filesystems.nix ./hardware-configuration.nix ];

  # Enable swap.
  swapDevices = [ { device = "/var/swapfile"; size = 32768; } ];

  # Install Nvidia drivers.
  myNixOS.nvidia.enable = true;

  # Enable Bluetooth.
  hardware.bluetooth.enable = true;

  # Configure systemd-boot.
  boot.loader = {
    systemd-boot = {
      enable = true;

      # Disable the command line editor.
      editor = false;

      # Create our own Windows bootloader entry.
      windows."11" = {
        title = "Windows 11";
        sortKey = "a_windows";
        efiDeviceHandle = "HD0b";
      };

      extraInstallCommands = ''
        # Do not show the auto-generated Windows entry.
        echo "auto-entries false" >>/boot/loader/loader.conf

        # Set Windows as the default boot entry.
        ${pkgs.gnused}/bin/sed -i 's/default .*/default windows_11.conf/' /boot/loader/loader.conf
      '';
    };

    # Allow systemd-boot to modify EFI variables.
    efi.canTouchEfiVariables = true;

  };

  # Set the kernel command line parameters.
  boot.kernelParams = [ "quiet" "splash" "loglevel=3" "nowatchdog" ];

  # Set the hostname.
  networking.hostName = "shinobu";

  # Configure system secrets using sops-nix.
  sops = {
    defaultSopsFile = ./sops.yaml;
    secrets = {
      "my-password" = {
        neededForUsers = true;
      };
      "syncthing/cert.pem" = {
        owner = "ewan";
      };
      "syncthing/key.pem" = {
        owner = "ewan";
      };
    };
  };

  # Configure my user account.
  myNixOS.home-users."ewan" = {
    userConfig = ./home.nix;
    userSettings = {
      description = "Alex";
      hashedPasswordFile =
        "/run/secrets-for-users/my-password";
    };
  };

  # Enable YubiKey-based passwordless sudo.
  myNixOS.passwordlessSudo.enable = true;

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

  # Use tuigreet to log in.
  myNixOS.tuigreet.enable = true;

  # Install Hyprland, the tiling Wayland compositor.
  myNixOS.hyprland.enable = true;

  # Install sway, the i3-compatible Wayland compositor.
  myNixOS.sway.enable = true;

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

  # Enable CUPS.
  services.printing.enable = true;
  services.avahi.enable = true;
  services.system-config-printer.enable = true;

  # Enable SANE.
  hardware.sane.enable = true;
  services.saned.enable = true;
  users.users.ewan.extraGroups = [ "scanner" ];

  # Enable my custom system theme.
  myNixOS.style.enable = true;

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

    # Actual programs.
    filezilla gimp inkscape
    joplin-desktop plex-desktop
    qbittorrent simple-scan
    ungoogled-chromium variety
    vesktop yubioath-flutter
    zathura zoom-us zotero

    # Wayland IME support.
    unstable.spotify

    # Wine.
    wineWowPackages.stable
    winetricks

    # Gaming.
    gamescope lutris
    prismlauncher
    unigine-heaven

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
