{ pkgs, lib, config, ... }: {

  imports = [
    ./git.nix ./gpg.nix
    ./kitty ./nvim ./joplin
    ./firefox.nix ./thunderbird.nix
  ];

}
