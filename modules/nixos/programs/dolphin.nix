{ pkgs, lib, config, ... }: {

  options.myNixOS.dolphin.enable = lib.mkEnableOption "the dolphin ecosystem";

  config = lib.mkIf config.myNixOS.dolphin.enable {

    # Pull this in just in case.
    myNixOS.graphical-environment = true;

    # Install dolphin and all that's good with it.
    environment.systemPackages = with pkgs; [

      kdePackages.ark
      kdePackages.dolphin
      kdePackages.dolphin-plugins
      kdePackages.ffmpegthumbs
      kdePackages.gwenview
      kdePackages.kimageformats
      kdePackages.kio-admin
      kdePackages.kio-extras
      kdePackages.konsole
      kdePackages.qtsvg

    ];

    # This fixes the unpopulated MIME menus.
    environment.etc = let
      plasma-applications = builtins.readFile
        "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";
    in {
      "/xdg/menus/sway-applications.menu".text = "${plasma-applications}";
      "/xdg/menus/Hyprland-applications.menu".text = "${plasma-applications}";
    };
  };
}
