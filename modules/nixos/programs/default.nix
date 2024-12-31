{ pkgs, lib, config, ... }: {

  imports = [
    ./dolphin.nix ./firefox.nix
    ./fcitx5.nix ./vim.nix
  ];

}
