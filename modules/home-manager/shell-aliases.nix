{
  home.shellAliases = {
    # Handy aliases for building NixOS configurations from my flake.
    nixos-switch = "sudo nixos-rebuild switch --flake ~/Git/nixos-configs";
    nixos-build = "nixos-rebuild build --flake ~/Git/nixos-configs";

    # Manage connection to my VPN server.
    vpnup = "nmcli c up Koakuma_VPN";
    vpndown = "nmcli c down Koakuma_VPN";

    # Make dmesg output more readable and friendly.
    dmesg = "sudo dmesg --human --reltime --color=always | less";
  };
}
