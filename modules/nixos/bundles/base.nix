{ pkgs, ... }: {

  environment = {

    systemPackages = with pkgs; [

      curl
      dig
      nmap
      wget

      file
      findutils

      ffmpeg
      imagemagick
      yt-dlp

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
      rsync

      usbutils

    ];

    variables = {

      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
      XDG_CACHE_HOME = "$HOME/.cache";

    };

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
