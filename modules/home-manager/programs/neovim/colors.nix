{ config, ... }:

let
  # Use the global Stylix colors.
  colors = stylix.colors.withHashtag;
  inherit (config.lib) stylix;
in

{
  stylix.targets.nixvim = {
    plugin = "base16-nvim";
  };

  programs.nixvim = {

    highlightOverride = {

      TablineSel = {
        bg = colors.base0D;
      };

      WhichKeyDesc = {
        fg = colors.base05;
      };

      WhichKeyGroup = {
        fg = colors.base05;
      };

    };

  };
}
