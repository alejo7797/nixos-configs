{ config, lib, pkgs, ... }:

let
  inherit (config.users) groups;
  inherit (groups) lp networkmanager scanner wheel;
in

{

  users.users.ewan = {
    shell = pkgs.zsh;
    hashedPasswordFile = config.sops.secrets.my-password.path;
    extraGroups = [ wheel.name ]
      ++ lib.optional config.networking.networkmanager.enable networkmanager.name
      ++ lib.optionals config.services.saned.enable [ scanner.name lp.name ];
    isNormalUser = true; linger = true;
  };

  home-manager.users.ewan = import ./home.nix;

  programs.zsh.enable = true;

  sops.secrets.my-password = { neededForUsers = true; };

}
