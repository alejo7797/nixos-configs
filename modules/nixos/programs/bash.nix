{
  programs.bash = {

    interactiveShellInit = ''
      # Avoid creating a ~/.bash_history file.
      HISTFILE=$HOME/.local/state/bash/history
    '';

  };
}
