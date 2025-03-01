{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.myNixOS.dolphin;
in

{
  options.myNixOS.dolphin.enable = lib.mkEnableOption "the Dolphin ecosystem";

  config = lib.mkIf cfg.enable {

    # Pull this in just in case.
    myNixOS.graphical.enable = true;

    # Install Dolphin and all that's good with it.
    environment.systemPackages = with pkgs.kdePackages; [

      ark dolphin dolphin-plugins ffmpegthumbs
      gwenview kde-cli-tools kfind kimageformats
      kdegraphics-thumbnailers kio-admin konsole
      kio-extras qtimageformats qtsvg taglib

    ];

    environment.etc =
      let
        plasma-applications = # This fixes the unpopulated MIME application menus in Dolphin and others.
          builtins.readFile "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
      in
      {
        "/xdg/menus/i3-applications.menu".text = "${plasma-applications}";
        "/xdg/menus/Hyprland-applications.menu".text = "${plasma-applications}";
        "/xdg/menus/sway-applications.menu".text = "${plasma-applications}";
      };

  };
}
