{
  home.shellAliases = rec {
    # Handy aliases for building NixOS configurations from my flake.
    nixos-switch = "sudo nixos-rebuild switch --flake ~/Git/nixos-configs";
    nixos-build = "nixos-rebuild build --flake ~/Git/nixos-configs";

    # Manage connection to AirVPN.
    airvpn = "nmcli -t c show | grep -E wg0$ | cut -d : -f 1";
    vpndown = "export airvpn=$(${airvpn}) && nmcli c down $airvpn";
    vpnup = "nmcli c up $airvpn";

    # Make dmesg output more readable and friendly.
    dmesg = "sudo dmesg --human --reltime --color=always | less";
  };
}
