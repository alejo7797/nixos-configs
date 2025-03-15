{ lib, pkgs, ... }: {

  environment.systemPackages = with pkgs; [

    curl dig file findutils
    ffmpeg htop imagemagick jq
    lm_sensors lsd lsof ncdu
    neofetch nmap procps psmisc
    rsync sops unar usbutils
    wireguard-tools wget yt-dlp

  ];

  programs = {

    git = {
      enable = true;
      package = pkgs.gitFull;
    };

    vim = {
      enable = true;
      defaultEditor = true;
    };

  };

  services = {

    openssh.enable = true;

    timesyncd.enable = lib.mkDefault true;

  };

  security = {

    polkit.enable = true;

    sudo.enable = true;

  };
}
