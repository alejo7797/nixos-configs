{ config, lib, pkgs, ... }:

let
  cfg = config.services.gpg-agent;
in

lib.mkIf cfg.enable {

  services.gpg-agent = {
    pinentryPackage = pkgs.pinentry-gnome3;

    # Replace ssh-agent.
    enableSshSupport = true;
    maxCacheTtl = 7200;
  };

  home.packages = [ pkgs.gcr ];

}
