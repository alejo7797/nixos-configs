{ config, lib, pkgs, ... }:

let
  inherit (config.users) groups;
  inherit (config.sops) secrets;
in

{
  users.users.ewan = {

    isNormalUser = true;

    linger = true;

    shell = pkgs.zsh;

    hashedPasswordFile = secrets.my-password.path;

    extraGroups = with groups; [ wheel.name ]
      ++ lib.optional config.networking.networkmanager.enable networkmanager.name
      ++ lib.optionals config.services.saned.enable [ scanner.name lp.name ];

    # Public SSH key coming from my personal OpenPGP key.
    openssh.authorizedKeys.keyFiles = [ ./id_rsa.pub ];
  };


  # Set up Home Manager for my user account.
  home-manager.users.ewan = import ./home.nix;

  # Make my password available during activation.
  sops.secrets.my-password.neededForUsers = true;

  # Set up system Zsh config.
  programs.zsh.enable = true;
}
