{ ... }:

{
  imports = [
    ./joplin ./firefox.nix ./geogebra
    ./git.nix ./gpg.nix ./keepassxc ./zsh
    ./kitty ./mpv.nix ./neovim ./zathura.nix
    ./ssh.nix ./thunderbird.nix ./variety
  ];
}
