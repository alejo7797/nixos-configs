{
  lib,
  config,
  ...
}:

let
  cfg = config.myHome.zathura;
in

{
  options.myHome.zathura.enable = lib.mkEnableOption "Zathura";

  config = lib.mkIf cfg.enable {

    programs.zathura = {
      enable = true;

      options =
        let
          getColorCh = colorName: channel: config.lib.stylix.colors."${colorName}-rgb-${channel}";
          rgb = color: "rgb(${getColorCh color "r"}, ${getColorCh color "g"}, ${getColorCh color "b"})";
        in
        {
          # Copy text to the clipboard.
          selection-clipboard = "clipboard";

          # Show scrollbars.
          guioptions = "shv";

          # The default Stylix look is not great.
          statusbar-fg = lib.mkForce (rgb "base06");
          statusbar-bg = lib.mkForce (rgb "base00");
        };
    };
  };
}
