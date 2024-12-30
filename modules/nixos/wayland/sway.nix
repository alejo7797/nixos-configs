{ pkgs, lib, config, ... }: {

  options.myNixOS.sway.enable = lib.mkEnableOption "sway";

  config = lib.mkIf config.myNixOS.sway.enable {

    # Install a bunch of Wayland-specific goodies.
    myNixOS.wayland.enable = true;

    # Install sway, the i3-compatible Wayland compositor.
    programs.sway = {

      enable = true;
      wrapperFeatures.gtk = true;
      extraPackages = [ ];

      extraSessionCommands = ''

        # Useful Wayland environment variables to set.
        export _JAVA_AWT_WM_NONREPARENTING=1
        export QT_WAYLAND_DISABLE_WINDOWDECORATION=1

        # https://fcitx-im.org/wiki/Using_Fcitx_5_on_Wayland#Sway.
        export QT_IM_MODULE=fcitx

        # Run Electron apps under XWayland.
        export ELECTRON_OZONE_PLATFORM_HINT=x11

      '';

      # Let sway now if we are using Nvidia drivers.
      extraOptions = lib.mkIf config.myNixOS.nvidia.enable [ "--unsupported-gpu" ];

    };

    # Configure UWSM to manage sway.
    programs.uwsm = {
      enable = true;
      waylandCompositors.sway = {
        prettyName = "Sway";
        binPath = "/run/current-system/sw/bin/sway";
        comment = "Sway compositor managed by UWSM";
      };
    };

  };
}
