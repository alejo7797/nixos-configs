{ config, lib, pkgs, ... }: {

  users.users.ewan = {
    shell = pkgs.zsh;
    hashedPasswordFile = config.sops.secrets.my-password.path;
    extraGroups = [ "wheel" ]
      ++ lib.optional config.networking.networkmanager.enable "networkmanager"
      ++ lib.optionals config.services.saned.enable [ "scanner" "lp" ];
    isNormalUser = true; linger = true;
  };

  home-manager.users.ewan = import ./home.nix;

  programs.zsh.enable = true;

  sops.secrets.my-password = { neededForUsers = true; };

}
