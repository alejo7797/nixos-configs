{ pkgs, ... }: {

  # Essential packages to install globally.
  environment.systemPackages = with pkgs; [

    # See the following for packages that get included:
    # ${modulesPath}/tasks/network-interfaces.nix
    # ${modulesPath}/config/system-path.nix

    file
    htop
    jq
    lsof
    ncdu
    neofetch
    nmap
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
