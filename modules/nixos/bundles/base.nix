{ pkgs, ... }: {

  boot.loader = {
    systemd-boot.enable = true;
  };

  security = {
    sudo.enable = true;
  };

  environment.systemPackages = with pkgs; [
    dig
    dua
    fastfetch
    file
    jq
    lsof
    nmap
    psmisc
    sqlite
    unar
    usbutils
  ];

  programs = {
    git.enable = true;
    vim.enable = true;
  };

  services = {
    openssh.enable = true;
    timesyncd.enable = true;
  };

}
