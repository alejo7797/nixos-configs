{ pkgs, lib, config, ... }: {

  imports = [

    ./git.nix ./gpg.nix
    ./kitty ./nvim ./joplin.nix
    ./firefox.nix ./thunderbird.nix

  ];

}
