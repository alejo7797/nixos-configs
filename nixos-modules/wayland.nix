{ pkgs, lib, config, ... }: {

    options.myNixOS.wayland.enable = lib.mkEnableOption "wayland";

    config = lib.mkIf config.myNixOS.wayland.enable {

      # Install some basic graphical utlities.
      myNixOS.graphical-environment = true;

      # Integrate Fcitx5 with Wayland.
      i18n.inputMethod.fcitx5.waylandFrontend = true;

      # Let hyprlock authenticate users.
      security.pam.services.hyprlock = {};

      # Install a bunch of Wayland-specific goodies.
      environment.systemPackages = with pkgs; [

        bemenu brightnessctl gammastep
        wf-recorder wl-clipboard

        libsForQt5.qt5.qtwayland
        kdePackages.qtwayland

      ];

    };

}
