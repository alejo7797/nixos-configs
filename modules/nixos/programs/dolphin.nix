{ pkgs, lib, config, ... }: {

  options.myNixOS.dolphin.enable = lib.mkEnableOption "the Dolphin ecosystem";

  config = lib.mkIf config.myNixOS.dolphin.enable {

    # Pull this in just in case.
    myNixOS.graphical.enable = true;

    # Install dolphin and all that's good with it.
    environment.systemPackages = with pkgs.kdePackages; [

      ark dolphin dolphin-plugins ffmpegthumbs
      gwenview kde-cli-tools kdegraphics-thumbnailers
      kfind kimageformats kio-admin kio-extras
      konsole qtimageformats qtsvg taglib

    ];

    # This fixes the unpopulated MIME menus.
    environment.etc =
      let
        plasma-applications = builtins.readFile
          "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
      in
      {
        "/xdg/menus/Hyprland-applications.menu".text = "${plasma-applications}";
        "/xdg/menus/i3-applications.menu".text = "${plasma-applications}";
        "/xdg/menus/sway-applications.menu".text = "${plasma-applications}";
      };

  };
}
