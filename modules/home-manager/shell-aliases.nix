{ lib, ... }:

let
  rebuild-args = lib.concatStringsSep " " [

    # Some basic build output logging.
    "--print-build-logs" "--verbose"

    # Path to my personal NixOS configs.
    "--flake ~/Git\ Repos/nixos-configs"

    # Used by nix-output-monitor.
    "--log-format internal-json"

  ];
in

{
  home.shellAliases = {

    # Handy aliases for building NixOS configurations from my flake.
    nixos-switch = "sudo nixos-rebuild switch ${rebuild-args} |& nom --json";
    nixos-build = "nixos-rebuild build ${rebuild-args} |& nom --json";

    # Make dmesg output more readable, in color, and use a pager.
    dmesg = "sudo dmesg --human --reltime --color=always | less";

  };
}
