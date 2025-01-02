{ pkgs, lib, config, ... }: {

  imports = [
    ./dolphin.nix ./firefox.nix
    ./thunderbird.nix
    ./fcitx5.nix ./vim.nix
  ];

}
