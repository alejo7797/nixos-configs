{ pkgs, ... }:

{
  # Did you read the comment?
  system.stateVersion = "24.11";

  # Lock the root account ASAP!
  users.users.root.initialHashedPassword = "";

  imports = [
    ./filesystems.nix
    ./hardware-configuration.nix
  ];

  swapDevices = [ { device = "/var/swapfile"; size = 16384; } ];

  hardware.bluetooth.enable = true;

  boot.kernelParams = [
    "quiet"
    "nowatchdog"
  ];

  networking.hostName = "satsuki";

  sops.secrets = { };

  myNixOS = {

    home-users."ewan" = {
      userConfig = ./home.nix;
      userSettings = {
        description = "Alex";
        initialPassword = "password";
      };
    };

    dolphin.enable = true;
    hyprland.enable = true;
    sway.enable = true;
    tuigreet.enable = true;

  };

  networking.networkmanager.enable = true;
  services.resolved.enable = true;

  time.timeZone = "America/New_York";

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
    vesktop zotero

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
