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

      CmpItemAbbr = {
        fg = colors.base05;
      };

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

      WhichKeyDesc = {
        fg = colors.base05;
      };
      WhichKeyGroup = {
        fg = colors.base05;
      };

      WhichKeyIconOrange = {
        fg = colors.base09;
      };
      WhichKeyIconPurple = {
        fg = colors.base0E;
      };
      WhichKeyIconYellow = {
        fg = colors.base0A;
      };

    };

  };
}
