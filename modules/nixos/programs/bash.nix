{
  programs.bash = {

    interactiveShellInit = ''
      # Keep history out of users' $HOME.
      HISTFILE=$HOME/.local/state/bash/history
      mkdir -p "$(dirname "$HISTFILE")"
    '';

  };
}
