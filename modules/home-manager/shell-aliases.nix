{
  home.shellAliases = {
    # Handy aliases for building NixOS configurations from my flake.
    nixos-switch = "sudo nixos-rebuild switch --flake ~/Git/nixos-configs";
    nixos-build = "nixos-rebuild build --flake ~/Git/nixos-configs";

    # Make dmesg output more readable, in color, and use a pager.
    dmesg = "sudo dmesg --human --reltime --color=always | less";
  };
}
