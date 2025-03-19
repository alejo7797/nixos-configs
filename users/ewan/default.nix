{ config, lib, pkgs, ... }:

let
  inherit (config.users) groups;
  inherit (config.sops) secrets;
in

{
  users.users.ewan = {

    # Common settings for 'real' users.
    isNormalUser = true; linger = true;

    # Set user shell.
    shell = pkgs.zsh;

    # Use `mkpasswd -m sha-512` to get a new hash.
    hashedPasswordFile = secrets.my-password.path;

    # Public SSH key coming from my personal OpenPGP key.
    openssh.authorizedKeys.keyFiles = [ ./id_rsa.pub ];

    extraGroups = with groups;

      # Admin group.
      [ wheel.name ]

      # Give access to the NetworkManager daemon: configure and add new networks.
      ++ lib.optional config.networking.networkmanager.enable networkmanager.name

      # Give access to local - and remote - scanners using the SANE library.
      ++ lib.optionals config.hardware.sane.enable [ lp.name scanner.name ]

    ;
  };


  # Home Manager module with personal configs.
  home-manager.users.ewan = import ./home.nix;

  # Make my password available during activation.
  sops.secrets.my-password.neededForUsers = true;

  # Set up system Zsh config.
  programs.zsh.enable = true;
}
