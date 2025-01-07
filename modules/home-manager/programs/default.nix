{ ... }: {

  imports = [
    ./git.nix ./gpg.nix ./kitty
    ./nvim ./joplin ./zathura.nix
    ./firefox.nix ./thunderbird.nix
  ];

}
