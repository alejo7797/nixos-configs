{
  programs.vim = {
    defaultEditor = true;
  };

  environment.interactiveShellInit = ''
    if [[ ! -f "$XDG_CONFIG_HOME/vim/vimrc" ]]; then
      mkdir -p "$XDG_CONFIG_HOME/vim"
      mkdir -p "$XDG_STATE_HOME/vim"
      echo "set viminfofile=$XDG_STATE_HOME/vim/viminfo" >"$XDG_CONFIG_HOME/vim/vimrc"
    fi
  '';
}
