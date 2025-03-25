{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.networking.firewall;
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

  config = {

    networking.firewall = lib.mkMerge [

      {
        # Issues with Wireguard.
        checkReversePath = false;

        # Reduce kernel log verbosity.
        logRefusedConnections = false;
      }

      (lib.mkIf (cfg.my.no-vpn != [ ]) {

        extraPackages = [ pkgs.dig ];

        extraStopCommands = ''
          ip46tables -t mangle -D OUTPUT -j dest-filter 2>/dev/null || true
          ip46tables -t nat -D POSTROUTING -m mark --mark 0xcbca -j MASQUERADE
        '';

        extraCommands =
          ''
            ip46tables -t mangle -F dest-filter 2>/dev/null || true
            ip46tables -t mangle -X dest-filter 2>/dev/null || true
            ip46tables -t mangle -N dest-filter

            iptables -A INPUT -s 9.9.9.9 -p udp --sport 53 -j ACCEPT
          ''
          +
          lib.flip (lib.concatMapStringsSep "\n") cfg.my.no-vpn
            (
              name: ''
                ipv4=$(dig +short @9.9.9.9 A ${name} | grep -v "\.$" || true)
                if [[ -n "$ipv4" ]]; then
                  iptables -t mangle -A dest-filter -d "$ipv4" -j MARK --set-mark 0xcbca
                fi

                ipv6=$(dig +short @9.9.9.9 AAAA ${name} | grep -v "\.$" || true)
                if [[ -n "$ipv6" ]]; then
                  ip6tables -t mangle -A dest-filter -d "$ipv6" -j MARK --set-mark 0xcbca
                fi
              ''
            )
          +
          ''
            iptables -D INPUT -s 9.9.9.9 -p udp --sport 53 -j ACCEPT

            ip46tables -t nat -A POSTROUTING -m mark --mark 0xcbca -j MASQUERADE
            ip46tables -t mangle -A OUTPUT -j dest-filter
          '';

      })

    ];

  };
}
