{ lib, pkgs, ... }: {

  boot.loader = {
    systemd-boot.enable = lib.mkDefault true;
  };

  security = {
    sudo.enable = true;
  };

  fonts = {
    fontconfig.enable = lib.mkDefault false;
  };

  environment.systemPackages = with pkgs; [
    dig
    dua
    fastfetch
    file
    jq
    kitty.terminfo
    lsof
    nix-output-monitor
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
