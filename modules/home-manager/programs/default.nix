{ ... }:

{
  imports = [
    ./joplin ./firefox.nix ./git.nix
    ./gpg.nix ./keepassxc ./kitty ./mpv.nix
    ./neovim ./ssh.nix ./thunderbird.nix
    ./variety ./zathura.nix ./zsh
  ];
}
