{ config, lib, ... }:

let
  cfg = config.networking.my.airvpn;

  publicKey = "PyLCXAQT8KkM4T+dUsOQfn+Ub3pGxfGlxkIApuig+hk=";

  mkAirVPN = id: server: {

    connection = {
      inherit id;
      inherit (server) autoconnect;
      inherit (cfg) interface-name;
      type = "wireguard";
    };

    ipv4 = {
      address1 = "${cfg.address}/32";
      dns = "10.128.0.1;";
      dns-search = "~;";
      method = "manual";
    };

    ipv6 = {
      addr-gen-mode = "stable-privacy";
      address1 = "${cfg.address6}/128";
      dns = "fd7d:76ee:e68f:a993::1;";
      dns-search = "~;";
      method = "manual";
    };

    wireguard = {
      inherit (cfg) fwmark;
      private-key = "$AIRVPN_PRIVATE_KEY";
    };

    "wireguard-peer.${publicKey}" = {
      allowed-ips = "0.0.0.0/0;::/0;";
      inherit (server) endpoint;
      persistent-keepalive = 15;
      preshared-key = "$AIRVPN_PRESHARED_KEY";
      preshared-key-flags = 0;
    };

  };
in

{
  options.networking.my.airvpn = {

    enable = lib.mkEnableOption "AirVPN NetworkManager profiles";

    address = lib.mkOption {
      description = ''
        IPv4 address of the AirVPN Wireguard interface.
      '';
      type = lib.types.str;
    };

    address6 = lib.mkOption {
      description = ''
        IPv6 address of the AirVPN Wireguard interface.
      '';
      type = lib.types.str;
    };

    fwmark = lib.mkOption {
      description = ''
        32-bit fwmark to use to identify outgoing packets.
      '';
      type = lib.types.int;
      default = 52170;
    };

    interface-name = lib.mkOption {
      description = ''
        Common name for the AirVPN Wireguard interface.
      '';
      type = lib.types.str;
      default = "wg0";
    };

    servers = lib.mkOption {
      description = ''
        AirVPN server configurations.
      '';
      type = with lib.types; attrsOf (submodule {
        options = {
          endpoint = lib.mkOption {
            description = ''
              Public IP address and Wireguard port of AirVPN server.
            '';
            type = str;
          };
          autoconnect = lib.mkEnableOption "automatic connection to this server";
        };
      });
    };

  };

  config = lib.mkIf cfg.enable {

    networking = {

      my.airvpn.servers = {
        AirVPN_NYC.endpoint = "198.44.136.254:1637";
        AirVPN_Japan.endpoint = "jp3.vpn.airdns.org:1637";
        AirVPN_Spain.endpoint = "185.93.182.173:1637";
        AirVPN_Suisse.endpoint = "ch3.vpn.airdns.org:1637";
        AirVPN_UK.endpoint = "gb3.vpn.airdns.org:1637";
      };

      networkmanager.ensureProfiles.profiles = lib.mapAttrs mkAirVPN cfg.servers;

    };

  };
}
