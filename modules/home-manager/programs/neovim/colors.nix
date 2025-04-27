{ config, ... }:

# Pull our color definitions from Stylix.
with config.lib.stylix.colors.withHashtag;

{
  programs.nixvim = {

    highlightOverride = {

      # Fix some UI elements.
      MiniIconsBlue.fg = base0D;
      MiniIconsGrey.fg = base04;
      MatchParen.fg = base0A;

      DiagnosticFloatingError = {
        fg = base08;
        bg = base00;
      };
      DiagnosticFloatingWarn = {
        fg = base0E;
        bg = base00;
      };
      DiagnosticFloatingInfo = {
        fg = base0C;
        bg = base00;
      };
      DiagnosticFloatingHint = {
        fg = base0D;
        bg = base00;
      };
      DiagnosticFloatingOk = {
        fg = base0B;
        bg = base00;
      };

      LineNr = {
        fg = base03;
        bg = base00;
      };

      # Matching color options.
      LineNrBelow.link = "LineNr";
      LineNrAbove.link = "LineNr";
      SignColumn.link = "LineNr";

      GitSignsAdd = {
        fg = base0B;
        bg = base00;
      };
      GitSignsChange = {
        fg = base0E;
        bg = base00;
      };
      GitSignsDelete = {
        fg = base08;
        bg = base00;
      };
      GitSignsUntracked = {
        fg = base0C;
        bg = base00;
      };

      NormalFloat = {
        link = "Normal";
      };

      PMenu = {
        link = "NormalFloat";
      };
      PMenuKind = {
        link = "NormalFloat";
      };
      PMenuExtra = {
        link = "NormalFloat";
      };

      WhichKeyDesc = {
        link = "Normal";
      };
      WhichKeySeparator = {
        link = "NormalFloat";
      };
      WhichKeyGroup = {
        link = "Normal";
      };

      WinSeparator = {
        link = "Normal";
      };

    };

  };
}
