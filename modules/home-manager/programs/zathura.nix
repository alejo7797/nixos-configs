{ config, lib, ... }:

let
  getColorCh = colorName: channel: config.lib.stylix.colors."${colorName}-rgb-${channel}";
  rgb = color: "rgb(${getColorCh color "r"}, ${getColorCh color "g"}, ${getColorCh color "b"})";
in

{
  programs.zathura = {

    options = {
      # Quality-of-life improvements to the UI and clipboard.
      selection-clipboard = "clipboard"; guioptions = "shv";

      # The default Stylix look is not great.
      statusbar-fg = lib.mkForce (rgb "base06");
      statusbar-bg = lib.mkForce (rgb "base00");
    };

  };
}
