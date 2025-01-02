{ pkgs, lib, config, ... }: {

  imports = [ ./hyprland.nix ./sway.nix ];

  options.myNixOS.wayland.enable = lib.mkEnableOption "Wayland";

  config = lib.mkIf config.myNixOS.wayland.enable {

    # Install some basic graphical utlities.
    myNixOS.graphical.enable = true;

    # Integrate Fcitx5 with Wayland.
    i18n.inputMethod.fcitx5.waylandFrontend = true;

    # Run Electron apps under Wayland.
    environment.sessionVariables.NIXOS_OZONE_WL = 1;

    # Let hyprlock authenticate users.
    security.pam.services.hyprlock = {};

    # Make nm-applet more resilient.
    systemd.user.services.nm-applet = {
      serviceConfig = {
        Restart = "on-failure";
        RestartSec = "800ms";
      };
    };

    # Install some Wayland-specific packages.
    environment.systemPackages = with pkgs; [

      bemenu hyprlock swaybg
      wf-recorder wl-clipboard
      libsForQt5.qt5.qtwayland
      kdePackages.qtwayland
      kdePackages.xwaylandvideobridge

    ];
  };
}
