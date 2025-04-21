{ pkgs, config, ... }: {

  home = {
    stateVersion = "24.11";

    shellAliases =
      let
        what-is-my-ip = "dig +short myip.opendns.com";
      in
      {
        # These rely on a custom firewall rule.
        pubip = "${what-is-my-ip} @resolver1.opendns.com";
        vpnip = "${what-is-my-ip} @resolver2.opendns.com";
      };
  };

  sops.secrets = {
    "borg/passphrase" = { };
    "borg/ssh-key" = { };
  };

  my.autostart = with pkgs; [
    altus
    firefox
    signal-desktop
    thunderbird
    zotero
  ];

  myHome = {
    # TODO: migrate this
    thunderbird.enable = true;
  };

  xdg.configFile."uwsm/env-hyprland".text = ''
    IGPU_CARD=$(readlink -f /dev/dri/by-path/pci-0000:00:02.0-card)
    DGPU_CARD=$(readlink -f /dev/dri/by-path/pci-0000:01:00.0-card)
    export AQ_DRM_DEVICES="$IGPU_CARD:$DGPU_CARD"
  '';

  services = {
    borgmatic.enable = true;
    syncthing.enable = true;

    kanshi.profiles =

      let
        laptop-screen = {
          criteria = "eDP-1"; scale = 1.0;
          mode = "1920x1080@60.033Hz";
        };

        home-monitor = {
          criteria = "ASUSTek COMPUTER INC ASUS VA27EHE N3LMTF145950";
          mode = "1920x1080@74.986Hz"; # I like this Asus monitor.
        };

        office-monitor = {
          criteria = "Samsung Electric Company S27R65 H4TT101982";
          mode = "1920x1080@74.973Hz"; # I got this one for free!
        };
      in

      {
        home.outputs = [
          (laptop-screen // { position = "1920,0"; })
          (home-monitor // { position = "0,0"; })
        ];

        office.outputs = [
          (laptop-screen // { position = "1920,0"; })
          (office-monitor // { position = "0,0"; })
        ];

        mobile.outputs = [
          (laptop-screen // { position = "0,0"; })
        ];
      };

  };

  wayland.windowManager.hyprland = {

    settings.device = [
      {
        name = "logitech-usb-receiver";
        sensitivity = -1; # For gaming.
      }
      {
        name = "logitech-b330/m330/m331-1";
        sensitivity = -1; # My office mouse.
      }
      {
        name = "telink-wireless-receiver-mouse";
        sensitivity = -1; # Only when I need it.
      }
    ];

    my.workspaces = {
      # TODO: look into improving this setting.
      "DP-1" = [ 1 2 3 4 5 6 7 8 9 10
        11 12 13 14 15 16 17 18 19 20 ];
      "eDP-1, persistent:true" = [ "name:extra" ];
    };

  };

  programs = {

    borgmatic = {
      enable = true;

      backups.personal = {

        consistency.checks = [
          # Some of these take a long time to run.
          { name = "repository"; frequency = "2 weeks"; }
          { name = "data"; frequency = "6 weeks"; }
        ];

        location = {
          patterns = [ "R /home/ewan" "- home/ewan/.cache" "- home/ewan/.local/share/Steam" ];
          repositories = [ { "path" = "ssh://patchouli/mnt/Hanekawa/Backup/satsuki/borg"; } ];
        };

        # You never know what might end up happening.
        retention = { keepDaily = 3; keepWeekly = 1; };

        storage = {
          # Use a dedicated private SSH key. Make sure not to bother me by trying to talk to the GnuPG SSH agent.
          extraConfig = { ssh_command = "${pkgs.openssh}/bin/ssh -o IdentityAgent=none -i ${config.sops.secrets."borg/ssh-key".path}"; };
          encryptionPasscommand = "${pkgs.coreutils}/bin/cat ${config.sops.secrets."borg/passphrase".path}";
        };
      };
    };

    waybar.my = {
      location = "Cambridge, MA";
      thermal-zone = 7;
    };

  };
}
