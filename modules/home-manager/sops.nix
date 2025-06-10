{ config, lib, ... }:

let
  cfg = config.sops;
in

{
  sops = {
    defaultSopsFile = ../../secrets/${config.home.username}.yaml;
    gnupg.home = "/dev/null"; # Don't even try to use my PGP key.
  };

  systemd.user.services.sops-nix = {

    Install.WantedBy = lib.mkForce (
      if (cfg.gnupg.home != null && cfg.gnupg.home != "/dev/null") then [ "graphical-session-pre.target" ] else [ "default.target" ]
    );

  };

}
