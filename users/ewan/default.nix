{ config, lib, pkgs, ... }:

let
  inherit (config.users) groups;
  inherit (config.sops) secrets;
in

{
  users.users.ewan = {

    # Common settings for real users, set the user shell.
    isNormalUser = true; linger = true; shell = pkgs.zsh;

    # Use `mkpasswd -m sha-512` to get a new hash.
    hashedPasswordFile = secrets.my-password.path;

    # Public SSH key coming from my personal OpenPGP key.
    openssh.authorizedKeys.keyFiles = [ ./id_rsa.pub ];

    extraGroups = with groups; [ wheel.name ]

      # Give permission to capture network traffic using Wireshark.
      ++ lib.optional config.programs.wireshark.enable wireshark.name

      # Give access to the NetworkManager daemon: configure and add new networks.
      ++ lib.optional config.networking.networkmanager.enable networkmanager.name

      # Give access to local - and remote - scanners using the SANE library.
      ++ lib.optionals config.hardware.sane.enable [ lp.name scanner.name ]

      # Give access to the Android Debug Bridge for USB devices.
      ++ lib.optional config.programs.adb.enable adbusers.name

    ;
  };

  # Home Manager module containing personal configs.
  home-manager.users.ewan = import ./home-manager;

  # Make my password available during activation.
  sops.secrets.my-password.neededForUsers = true;

  # Set up system Zsh config.
  programs.zsh.enable = true;
}
