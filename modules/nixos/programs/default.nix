{ pkgs, lib, config, ... }: {

  imports = [
    ./dolphin.nix ./firefox.nix
    ./fcitx5.nix ./vim.nix
  ];

  # Install Thunderbird extensions.
  programs.thunderbird.policies = {
    Extensions = {
      "Install" = [
        "https://addons.thunderbird.net/thunderbird/downloads/latest/darkreader/latest.xpi"
      ];
    };
  };

}
