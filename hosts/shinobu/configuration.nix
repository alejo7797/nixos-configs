{ pkgs, ... }:

{
  # Did you read the comment?
  system.stateVersion = "24.11";

  imports = [
    ./filesystems.nix
    ./hardware-configuration.nix
  ];

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

  sops.secrets = {
    "my-password" = { neededForUsers = true; };

    "nix-conf/gitlab-token" = { owner = "ewan"; };
    "syncthing/key.pem" = { owner = "ewan"; };

    "wireguard/koakuma/private-key" = { };
    "wireguard/koakuma/preshared-key" = { };
  };

  myNixOS = {

    home-users."ewan" = {
      userConfig = ./home.nix;
      userSettings = {
        extraGroups = [ "wheel" ];
      };
    };

    dolphin.enable = true;
    hyprland.enable = true;
    nvidia.enable = true;
    pam.sudo.yubikey = true;
    retroarch.enable = true;
    sway.enable = true;
    tuigreet.enable = true;

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
    ruby sage SnapPy
    biber texliveFull

  ];
}
