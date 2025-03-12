{
  environment.pathsToLink = [ "/share/zsh" ];

  programs = {
    zsh = {
      enable = true;
      shellInit = ''
        export ZDOTDIR="$HOME/.config/zsh"
      '';
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
    };
  };

}
