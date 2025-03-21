{ pkgs, ... }: {

  services.gpg-agent = {
    pinentryPackage = pkgs.pinentry-gnome3;

    # Replace ssh-agent.
    enableSshSupport = true;
    maxCacheTtl = 7200;
  };

}
