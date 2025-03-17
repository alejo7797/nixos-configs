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

      # these should go to
      # desktop.nix & patchouli
      # and that's it, no?

      htop
      lsof
      ncdu
      procps
      psmisc

      jq
      lsd
      sops
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
