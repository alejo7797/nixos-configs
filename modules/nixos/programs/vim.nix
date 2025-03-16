{
  programs.vim = {
    defaultEditor = true;
  };

  environment.interactiveShellInit = ''
    # Keep files out of users' $HOME.
    viminfo=$HOME/.local/state/vim/viminfo
    vimrc=$HOME/.config/vim/vimrc

    if [[ ! -f "$vimrc" ]]; then
      mkdir -p "$(dirname "$viminfo")"
      mkdir -p "$(dirname "$vimrc")"

      # Tell Vim where to keep the viminfo file.
      echo "set viminfofile=$viminfo" > "$vimrc"
    fi
  '';
}
