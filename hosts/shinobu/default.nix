{ pkgs, ... }:

{
  # Did you read the comment?
  system.stateVersion = "24.11";

  imports = [ ./filesystems.nix ./hardware.nix ../../users/ewan ];

  swapDevices = [ { device = "/var/swapfile"; size = 32768; } ];

  boot = {
    kernelParams = [ "quiet" "nowatchdog" ];

    loader = {
      systemd-boot = {
        enable = true;

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
  };

  hardware.bluetooth.enable = true;

  networking = {
    hostName = "shinobu";
    networkmanager.enable = true;
  };

  services.resolved.enable = true;

  time.timeZone = "Europe/Madrid";

  # TODO: refactor
  home-manager.sharedModules = [ ./home.nix ];

  sops.secrets = {
    "syncthing/cert.pem" = { owner = "ewan"; };
    "syncthing/key.pem" = { owner = "ewan"; };

    "wireguard/koakuma/private-key" = { };
    "wireguard/koakuma/preshared-key" = { };
  };

  my = {
    desktop.enable = true;
    nvidia.enable = true;
    yubikey.sudo = true;
  };

  myNixOS = {

    dolphin.enable = true;
    hyprland.enable = true;
    retroarch.enable = true;

  };

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
    digikam filezilla geogebra
    inkscape joplin-desktop krita
    gimp spotify vesktop zotero

    # Games and all that.
    bolt-launcher dosbox-x
    easyrpg-player mangohud
    lutris prismlauncher
    winetricks gamescope
    wineWowPackages.stable

    # Programming.
    clang jdk23 nodejs
    bundix bundler gap
    mathematica-webdoc
    knotjob snappy-math
    biber texliveFull
    sage khoca ruby

  ];
}
