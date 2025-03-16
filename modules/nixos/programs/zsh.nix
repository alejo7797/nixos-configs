{ config, ... }: {

  programs.zsh = {
    histFile = "$XDG_STATE_HOME/zsh/history";
    shellInit = ''
      # Keep Zsh config out of their $HOME directory.
      export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
    '';
    interactiveShellInit = ''
      mkdir -p "$(dirname "${config.programs.zsh.histFile}")"
    '';
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };

}
