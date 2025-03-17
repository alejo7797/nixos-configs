{ pkgs, ... }: {

  environment = {

    systemPackages = with pkgs; [

      curl
      dig
      nmap
      rsync
      wget

      file

      findutils

      htop
      lsof
      ncdu
      procps
      psmisc

      jq
      unar

      neofetch

      usbutils

    ];
  };

  programs = {
    git.enable = true;
    vim.enable = true;
  };

  services = {
    openssh.enable = true;
    timesyncd.enable = true;
  };

  security = {
    polkit.enable = true;
    sudo.enable = true;
  };
}
