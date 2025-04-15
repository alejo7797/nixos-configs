{ pkgs, ... }: {

  programs.wireshark = {

    # Select the GUI version.
    package = pkgs.wireshark;

  };
}
