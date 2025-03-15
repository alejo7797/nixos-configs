{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.myNixOS.tzupdate;
in

{
  options.myNixOS.tzupdate.enable = lib.mkEnableOption "automatic timezone updates";

  config = lib.mkIf cfg.enable {

    networking.networkmanager.dispatcherScripts = [
      {
        source = pkgs.writeText "tzupdate" ''

          ! [[ $1 =~ wlo[0-9] ]] && exit 0

          if [[ $2 == "up" ]]; then

            # Avoids using any VPN public IP addresses.
            ip=$(${pkgs.dig}/bin/dig +short myip.opendns.com @resolver1.opendns.com)

            # Procure the current timezone from our IP address.
            tz=$(${pkgs.curl}/bin/curl -s -f http://ip-api.com/line/"$ip_address"?fields=timezone)

            # Make sure we got an actual timezone as a response.
            if [[ -n $tz && -r ${pkgs.tzdata}/share/zoneinfo/$tz ]]; then

              # And finally, set the timezone.
              ${pkgs.systemd}/bin/timedatectl set-timezone $tz

            fi
          fi
        '';
      }
    ];
  };
}
