{ config, ... }: {

  programs.gpg = {

    # Keep GnuPG program data outside $HOME.
    homedir = "${config.xdg.dataHome}/gnupg";

    settings = {
      # Alternative to the Ubuntu keyserver.
      keyserver = "hkps://keys.openpgp.org";
    };

    scdaemonSettings = {
      # Prevent conflicts.
      disable-ccid = true;
    };

  };
}
