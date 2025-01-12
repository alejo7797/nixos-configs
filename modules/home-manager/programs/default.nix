{ ... }:

{
  imports = [
    ./joplin-desktop
    ./keepassxc ./kitty
    ./variety ./zsh

    ./firefox.nix ./git.nix
    ./gpg.nix ./neovim
    ./thunderbird.nix
    ./zathura.nix
  ];
}
