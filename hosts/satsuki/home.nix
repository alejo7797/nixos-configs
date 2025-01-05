{ pkgs, lib, config, ... }: {

  # Basic settings needed by Home Manager.
  home.username = "ewan";
  home.homeDirectory = "/home/ewan";
  home.stateVersion = "24.11";

  # Enable Arch-Linux quirks.
  myHome.arch-linux.enable = true;

  # Specify the system hostname.
  myHome.hostName = "satsuki";

  # Load up our custom theme.
  myHome.style.enable = true;

  # Set up Hyprland, the tiling Wayland compositor.
  myHome.hyprland.enable = true;

  # Set up sway, the i3-compatible Wayland compositor.
  myHome.sway.enable = true;

  # Host-specific environment variables.
  xdg.configFile."uwsm/env".text = ''

    # Use integrated graphics.
    export __GLX_VENDOR_LIBRARY_NAME=mesa
    export __EGL_VENDOR_LIBRARY_FILENAMES=/usr/share/glvnd/egl_vendor.d/50_mesa.json

  '';

  # Configure outputs.
  services.kanshi.settings = [
    {
      profile.name = "home";
      profile.outputs = [
        {
          criteria = "ASUSTek COMPUTER INC ASUS VA27EHE N3LMTF145950";
          mode = "1920x1080@74.986Hz";
          position = "0,0";
        }
        {
          criteria = "eDP-1";
          mode = "1920x1080@60.033Hz";
          position = "1920,0";
        }
      ];
    }     {
      profile.name = "office";
      profile.outputs = [
        {
          criteria = "Samsung Electric Company S27R65 H4TT101982";
          mode = "1920x1080@74.973Hz";
          position = "0,0";
        }
        {
          criteria = "eDP-1";
          mode = "1920x1080@60.033Hz";
          position = "1920,0";
        }
      ];
    }
   {
      profile.name = "mobile";
      profile.outputs = [
        {
          criteria = "eDP-1";
          mode = "1920x1080@60.033Hz";
          position = "0,0";
        }
      ];
    }
  ];

  # Host-specific Hyprland configuration.
  wayland.windowManager.hyprland.settings = {
    device = [
      {
        name = "logitech-usb-receiver";
        sensitivity = -1;
      }
      {
        name = "logitech-b330/mm330/m331-1";
        sensitivity = -1;
      }
    ];
    bindl = [
      ", switch:on:Lid Switch, exec, hyprctl keyword monitor \"eDP-1, disable\""
      ", switch:off:Lid Switch, exec, hyprctl keyword monitor \"eDP-1, preferred, 1\""
    ];
    workspace =
      map (w: "${builtins.toString w}, monitor:DP-1")
        [ 1 2 3 4 6 8 9 10 ]
      ++ map (w: "${builtins.toString w}, monitor:eDP-1")
        [ 5 7 ];
  };

  # Host-specific sway configuration.
  wayland.windowManager.sway.config = {
    input = {
      "1133:50503:K=Logitech_USB_Receiver" = {
        pointer_accel = "-1";
      };
      "1133:16471:Logitech_B330/M330/M331" = {
        pointer_accel = "-1";
      };
      "9354:33639:SYNA329D:00_06CB:CE14_Touchpad" = {
        tap = "enabled";
        dwt = "enabled";
      };
    };
    startup = [{
      always = true;
      command = "${./clamshell}";
    }];
    workspaceOutputAssign =
      map (w: { workspace = "${builtins.toString w}"; output = "DP-1"; })
        [ 1 2 3 4 6 8 9 10 ]
      ++ map (w: { workspace = "${builtins.toString w}"; output = "eDP-1"; })
        [ 5 7 ];
  };

  # Thermal zone to use in waybar.
  myHome.waybar.thermal-zone = 7;

  # Let's leave Firefox alone for now.
  myHome.firefox.enable = lib.mkForce false;

  # Host-specific Zsh configuration.
  programs.zsh = {

    # Host-specific aliases.
    shellAliases =
      let
        what-is-my-ip = "${pkgs.dig}/bin/dig +short myip.opendns.com";
      in {
        # Legacy dotfiles implementation.
        dotfiles = "${pkgs.git}/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME";

        # These rely on a custom firewall rule.
        pubip = "${what-is-my-ip} @resolver1.opendns.com";
        vpnip = "${what-is-my-ip} @resolver2.opendns.com";

        # Manage the wonderful toolchain.
        wf-pacman = "sudo -u wonderful /opt/wonderful/bin/wf-pacman";
      };
  };

  # Install packages to the user profile.
  home.packages = with pkgs; [
    nixfmt-rfc-style
    nixos-generators
    nixgl.nixGLIntel
  ];

}
