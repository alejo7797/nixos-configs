{ pkgs, ... }:

{
  # Did you read the comment?
  system.stateVersion = "24.11";

  # Include hardware configuration.
  imports = [
    ./filesystems.nix
    ./hardware-configuration.nix
  ];

  # Enable swap.
  swapDevices = [
    {
      device = "/var/swapfile";
      size = 32768;
    }
  ];

  # Enable Bluetooth.
  hardware.bluetooth.enable = true;

  # Configure systemd-boot.
  boot.loader = {
    systemd-boot = {

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
  };

  boot.kernelParams = [
    "quiet"
    "nowatchdog"
  ];

  networking.hostName = "shinobu";

  sops.secrets = {
    "my-password" = {
      neededForUsers = true;
    };

    "wireguard/koakuma/private-key" = { };
    "wireguard/koakuma/preshared-key" = { };

    "syncthing/cert.pem" = {
      owner = "ewan";
    };
    "syncthing/key.pem" = {
      owner = "ewan";
    };
  };

  myNixOS = {

    home-users."ewan" = {
      userConfig = ./home.nix;
      userSettings = {
        description = "Alex";
        hashedPasswordFile = "/run/secrets-for-users/my-password";
      };
    };

    dolphin.enable = true;
    hyprland.enable = true;
    nvidia.enable = true;
    pam.sudo.yubikey = true;
    sway.enable = true;
    tuigreet.enable = true;

  };

  networking.networkmanager.enable = true;
  services.resolved.enable = true;

  time.timeZone = "Europe/Madrid";

  programs = {
    gamemode.enable = true;
    thunderbird.enable = true;
    wireshark.enable = true;

    steam = {
      enable = true;
      protontricks.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [

    # Actual programs.
    filezilla
    gimp inkscape
    joplin-desktop
    vesktop zoom-us
    zotero

    # Wayland IME support.
    unstable.spotify

    wineWowPackages.stable
    winetricks

    gamescope
    lutris
    prismlauncher
    unigine-heaven

    biber clang
    gdb jupyter
    lldb perl
    ruby sage

    # LaTeX.
    (texliveMedium.withPackages
    (ps: with ps; [ collection-langcyrillic ]))

  ];
}
