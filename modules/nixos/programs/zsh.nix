{
  programs = {
    zsh = {
      enable = true;
      histFile = "$XDG_STATE_HOME/zsh/history";
      shellInit = ''
        # Keep Zsh config out of their $HOME directory.
        export ZDOTDIR="$$XDG_CONFIG_HOME/zsh"
      '';
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
    };
  };

}
