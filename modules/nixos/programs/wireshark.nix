{ pkgs, ... }: {

  programs.wireshark = {

    package = pkgs.wireshark;

  };
}
