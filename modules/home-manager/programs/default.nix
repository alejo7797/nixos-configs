{ ... }:

{
  imports = [
    ./borgmatic.nix ./joplin
    ./firefox.nix ./git.nix
    ./gpg.nix ./keepassxc
    ./kitty ./mpv.nix ./neovim
    ./variety ./thunderbird.nix
    ./zathura.nix ./zsh
  ];
}
