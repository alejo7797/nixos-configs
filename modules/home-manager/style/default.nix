{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:

let
  cfg = config.myHome.style;
in

{
  imports = [ ../../style.nix ];

  # Not available in our current version of Home Manager.
  disabledModules = [ "${inputs.stylix}/modules/ghostty/hm.nix" ];

  options.myHome.style.enable = lib.mkEnableOption "user theme components";

  config = lib.mkIf cfg.enable {

    # Enable common theme components.
    myStylix.enable = true;

    xdg = {
      # Fix the look of QT applications.
      configFile = {
        "kdeglobals".source = ./kdeglobals;
        "qt5ct/qt5ct.conf".source = ./qt5ct.conf;
        "qt6ct/qt6ct.conf".source = ./qt6ct.conf;
      };

      # Make our theme available to Konsole.
      configFile."konsolerc".source = ./konsole/konsolerc;
      dataFile."konsole".source = ./konsole/data;
    };

    # Set the NeoVim colorscheme.
    programs.nvf.settings.vim.theme = {
      enable = true;
      name = "base16";
      base16-colors = {
        inherit (config.lib.stylix.colors.withHashtag)
        base00 base01 base02 base03 base04 base05 base06 base07
        base08 base09 base0A base0B base0C base0D base0E base0F;
      };
    };

    # Set our desired font DPI.
    dconf.settings."org/gnome/desktop/interface" = {
      text-scaling-factor = 1.25;
    };

    # Use Papirus as our icon theme.
    stylix.iconTheme = {
      enable = true;
      package = pkgs.papirus-icon-theme;
      dark = "Papirus-Dark";
      light = "Papirus-Light";
    };

    # Use the default KDE sound theme.
    gtk = {
      gtk2.extraConfig = "gtk-sound-theme-name = ocean";
      gtk3.extraConfig.gtk-sound-theme-name = "ocean";
      gtk4.extraConfig.gtk-sound-theme-name = "ocean";
    };
    dconf.settings."org/gnome/desktop/sound".theme-name = "ocean";

    # Pass our settings to xsettingsd.
    services.xsettingsd.settings = {
      "Net/ThemeName" = "adw-gkt3";
      "Net/IconThemeName" = "Papirus-Dark";
      "Net/SoundThemeName" = "ocean";
      "Gtk/CursorThemeName" = "breeze_cursors";
      "Xft/DPI" = 122880;
    };
  };
}
