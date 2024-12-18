{ pkgs, lib, config, ... }: {

  options.myNixOS.sddm.enable = lib.mkEnableOption "SDDM";

  config = lib.mkIf config.myNixOS.sddm.enable  {

    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable and configure SDDM.
    services.displayManager = {

      # Set Hyprland as default when available.
      defaultSession = lib.mkIf config.myNixOS.hyprland.enable "hyprland";

      sddm = {
        enable = true;

        # Make it look nice.
        theme = "chili";
        settings = {
          Current = {
            CursorSize = 24;
            CursorTheme = "breeze_cursors";
          };
        };

      };

    };

    environment.systemPackages = with pkgs; [

      # To get access to the cursor theme.
      libsForQt5.breeze-qt5

      # And our theme configuration.
      (sddm-chili-theme.override {
        themeConfig = {
          background = "/var/public/sddm-bg.png";
          ScreenWidth = 1920;
          ScreenHeight = 1080;
        };
      })

    ];

  };

}
