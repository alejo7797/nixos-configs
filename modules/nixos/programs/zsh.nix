{
  programs.zsh = {

    # Keep files out of users' $HOME directory.
    shellInit = "export ZDOTDIR=$HOME/.config/zsh";
    histFile = "$HOME/.local/state/zsh/history";

    # Enable zsh-autosuggestions.
    autosuggestions.enable = true;

    # Enable zsh-syntax-highlighting.
    syntaxHighlighting.enable = true;

  };
}
