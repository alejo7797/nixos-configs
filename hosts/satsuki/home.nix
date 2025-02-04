{
  config,
  pkgs,
  ...
}:

{
  home = {
    username = "ewan";
    homeDirectory = "/home/ewan";
    stateVersion = "24.11";
  };

  sops.secrets = {
    "borg/passphrase" = { };
    "borg/ssh-key" = { };
    "calendars/harvard" = { };
    "calendars/sonarr" = { };
  };

  myHome = {
    laptop.enable = true;

    hyprland.enable = true;
    sway.enable = true;
    i3.enable = true;

    firefox.enable = true;
    thunderbird.enable = true;
    joplin-desktop.enable = true;

    workspaces = {
      "DP-1" = [ 1 2 3 4 6 8 9 10 ];
      "eDP-1" = [ 5 7 ];
    };

    waybar.thermal-zone = 7;
    waybar.wttr-location = "Cambridge, MA";

    xdgAutostart = with pkgs; [
      firefox thunderbird zotero
    ];
  };

  xdg.configFile."uwsm/env".text = ''
    export __EGL_VENDOR_LIBRARY_FILENAMES=/run/opengl-driver/share/glvnd/egl_vendor.d/50_mesa.json
    export __GLX_VENDOR_LIBRARY_NAME=mesa
  '';

  services = {
    borgmatic.enable = true;
    syncthing.enable = true;

    kanshi.settings =
      let
        laptop-screen = {
          criteria = "eDP-1";
          mode = "1920x1080@60.033Hz";
          scale = 1.0;
        };
        home-monitor = {
          criteria = "ASUSTek COMPUTER INC ASUS VA27EHE N3LMTF145950";
          mode = "1920x1080@74.986Hz";
        };
        office-monitor = {
          criteria = "Samsung Electric Company S27R65 H4TT101982";
          mode = "1920x1080@74.973Hz";
        };
      in
      [
        {
          profile.name = "home";
          profile.outputs = [
            (home-monitor // { position = "0,0"; })
            (laptop-screen // { position = "1920,0"; })
          ];
        }
        {
          profile.name = "office";
          profile.outputs = [
            (office-monitor // { position = "0,0"; })
            (laptop-screen // { position = "1920,0"; })
          ];
        }
        {
          profile.name = "mobile";
          profile.outputs = [
            (laptop-screen // { position = "0,0"; })
          ];
        }
      ];
  };

  wayland.windowManager.hyprland.settings = {
    device = [
      {
        name = "logitech-usb-receiver";
        sensitivity = -1;
      }
      {
        name = "logitech-b330/m330/m331-1";
        sensitivity = -1;
      }
    ];
  };

  wayland.windowManager.sway.config = {
    input = {
      "1133:50503:Logitech_USB_Receiver" = {
        pointer_accel = "-1";
      };
      "1133:16471:Logitech_B330/M330/M331" = {
        pointer_accel = "-1";
      };
      "1739:52756:SYNA329D:00_06CB:CE14_Touchpad" = {
        tap = "enabled"; dwt = "enabled";
      };
    };
  };

  programs = {

    borgmatic = {
      enable = true;

      backups.personal = {
        consistency.checks = [
          { name = "repository"; frequency = "2 weeks"; }
          { name = "data"; frequency = "6 weeks"; }
        ];
        location = {
          patterns = [ "R /home/ewan" "- home/ewan/.cache" "- home/ewan/.local/share/Steam" ];
          repositories = [ { "path" = "ssh://patchouli/mnt/Hanekawa/Backup/satsuki/borg"; } ];
        };
        retention = { keepDaily = 3; };
        storage = {
          encryptionPasscommand = "${pkgs.coreutils}/bin/cat ${config.sops.secrets."borg/passphrase".path}";
          extraConfig = { ssh_command = "${pkgs.openssh}/bin/ssh -o IdentityAgent=none -i ${config.sops.secrets."borg/ssh-key".path}"; };
        };
      };
    };

    zsh.shellAliases =
      let
        what-is-my-ip = "dig +short myip.opendns.com";
      in
      {
        # These rely on a custom firewall rule.
        pubip = "${what-is-my-ip} @resolver1.opendns.com";
        vpnip = "${what-is-my-ip} @resolver2.opendns.com";

        wf-pacman = "sudo -u wonderful /opt/wonderful/bin/wf-pacman";
      };

  };
}
