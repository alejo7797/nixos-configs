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

          [[ $1 != "wlan0" ]] && exit 0

          if [[ $2 == "up" ]]; then

            # Avoids using any VPN public IP addresses.
            ip=$(${pkgs.dig}/bin/dig +short myip.opendns.com @resolver1.opendns.com)

            # Procure the current timezone from our IP address.
            tz=$(${pkgs.tzupdate}/bin/tzupdate --print-only --ip "$ip")

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
