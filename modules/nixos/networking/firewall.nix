{ config, lib, pkgs, ... }:

let
  cfg = config.networking.firewall;

  vpn-whitelist = pkgs.writeShellScriptBin "vpn-whitelist"
    ''
      readarray -t ipv4 < <( dig +short @9.9.9.9 A "$1" | grep -v "\.$" )
      for ip in "''${ipv4[@]}"; do
        iptables -t mangle -A dest-filter -d "$ip" -j MARK --set-mark 0xcbca
      done

      readarray -t ipv6 < <( dig +short @9.9.9.9 AAAA "$1" | grep -v "\.$" )
      for ip in "''${ipv6[@]}"; do
        ip6tables -t mangle -A dest-filter -d "$ip" -j MARK --set-mark 0xcbca
      done
    '';
in

{
  options = {

    networking.firewall.my = {
      no-vpn = lib.mkOption {
        type = with lib.types; listOf str;
        description = ''
          Destinations for which traffic should
          not go into one of our VPN tunnels.
        '';
        example = [ "en.wikipedia.org" ];
        default = [ ];
      };
    };

  };

  config = lib.mkMerge [

    {
      networking.firewall = {
        # Issues with Wireguard.
        checkReversePath = false;

        # Reduce kernel log verbosity.
        logRefusedConnections = false;
      };
    }

    (lib.mkIf (cfg.my.no-vpn != [ ]) {

      networking.firewall = {

        extraStopCommands = ''
          ip46tables -t mangle -D OUTPUT -j dest-filter 2>/dev/null || true
          ip46tables -t nat -D POSTROUTING -m mark --mark 0xcbca -j MASQUERADE 2>/dev/null || true
        '';

        extraCommands = ''
          ip46tables -t mangle -F dest-filter 2>/dev/null || true
          ip46tables -t mangle -X dest-filter 2>/dev/null || true
          ip46tables -t mangle -N dest-filter

          ip46tables -t nat -A POSTROUTING -m mark --mark 0xcbca -j MASQUERADE
          ip46tables -t mangle -A OUTPUT -j dest-filter
        '';

      };

      systemd.services.firewall-post = {

        description = "My firewall script";
        path = [ cfg.package pkgs.dig ];

        wants = [ "network-online.target" ];
        wantedBy = [ "firewall.service" ];

        after = [
          "network-online.target"
          "firewall.service"
        ];

        serviceConfig = {
          Type = "oneshot";
        };

        script =
          lib.concatMapStringsSep "\n"
          (name: ''
            ${lib.getExe vpn-whitelist} ${name}
          '')
          cfg.my.no-vpn;

      };

      environment.systemPackages = [ vpn-whitelist ];

    })

  ];
}
