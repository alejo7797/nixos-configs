{ pkgs, ... }: {

  services.gpg-agent = {
    pinentryPackage = pkgs.pinentry-gnome3;

    # Replace ssh-agent.
    enableSshSupport = true;
    maxCacheTtl = 7200;

    # My personal authorization-capable OpenPGP subkey.
    sshKeys = [ "17EB61C7A5A1DD08599A38F19F1506B02CDAA88F" ];
  };

}
