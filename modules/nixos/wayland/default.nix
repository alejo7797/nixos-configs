{
  lib,
  config,
  pkgs,
  ...
}:

{
  options.myNixOS.wayland.enable = lib.mkEnableOption "Wayland";

  config = lib.mkIf config.myNixOS.wayland.enable {

    # Install some basic graphical utlities.
    myNixOS.graphical.enable = true;

    # Integrate Fcitx5 with Wayland.
    i18n.inputMethod.fcitx5.waylandFrontend = true;

    # Run Electron apps under Wayland.
    environment.sessionVariables.NIXOS_OZONE_WL = 1;

    # Let hyprlock authenticate users.
    security.pam.services.hyprlock = { };

    # Start nm-applet after WAYLAND_DISPLAY is set.
    systemd.user.services.nm-applet = {
      after = [ "graphical-session.target" ];
    };

    # Install some Wayland-specific packages.
    environment.systemPackages = with pkgs; [

      bemenu grimblast swww
      wf-recorder wl-clipboard
      libsForQt5.qt5.qtwayland
      kdePackages.qtwayland

    ];
  };
}
