{
  environment.pathsToLink = [ "/share/zsh" ];

  programs = {
    zsh = {
      enable = true;
      shellInit = ''
        export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
      '';
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
    };
  };

}
