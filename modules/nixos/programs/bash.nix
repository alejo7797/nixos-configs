{
  programs.bash = {

    interactiveShellInit = ''
      # Keep history out of users' $HOME.
      HISTFILE=$XDG_STATE_HOME/bash/history
      mkdir -p "$(dirname "$HISTFILE")"
    '';

  };
}
