{ pkgs, lib, config, ... }: {

    options.myNixOS.wayland.enable = lib.mkEnableOption "wayland";

    config = lib.mkIf config.myNixOS.wayland.enable {

      # Install some basic graphical utlities.
      myNixOS.graphical-environment = true;

      # Integrate Fcitx5 with Wayland.
      i18n.inputMethod.fcitx5.waylandFrontend = true;

      # Install a bunch of Wayland-specific goodies.
      environment.systemPackages = with pkgs; [

        brightnessctl gammastep
        hyprlock kanshi swaybg
        swayidle swaynotificationcenter
        waybar wf-recorder wofi
        wl-clipboard wlogout

        libsForQt5.qt5.qtwayland
        kdePackages.qtwayland

      ];

    };

}
