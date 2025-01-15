{ ... }:

{
  imports = [
    ./borgmatic.nix
    ./joplin ./firefox.nix
    ./git.nix ./gpg.nix
    ./keepassxc ./kitty
    ./neovim ./variety
    ./thunderbird.nix
    ./zathura.nix ./zsh
  ];
}
