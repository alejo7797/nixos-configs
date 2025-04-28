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

      DiagnosticOk = {
        fg = colors.base0B;
      };

      DiagnosticUnderlineInfo = {
        underline = true;
        sp = colors.base0D;
      };
      DiagnosticUnderlineHint = {
        undercurl = true;
        sp = colors.base0C;
      };
      DiagnosticUnderlineOk = {
        underline = true;
        sp = colors.base0B;
      };

      MiniIconsOrange = {
        fg = colors.base09;
      };
      MiniIconsPurple = {
        fg = colors.base0E;
      };
      MiniIconsYellow = {
        fg = colors.base0A;
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
