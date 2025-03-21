{ pkgs, ... }: {

  environment.systemPackages = with pkgs; [
    dua
    fastfetch
    file
    jq
    lsof
    nmap
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

  security = {
    sudo.enable = true;
  };
}
