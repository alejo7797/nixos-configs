{ lib, ... }: {

  programs.nixvim = {

    extraFiles = {
      # File with handy functions for snippets.
      "lua/_helpers.lua".source = ./helpers.lua;
    };

    plugins = {

      # Comprehensive set of snippets.
      friendly-snippets.enable = true;

      luasnip = {
        enable = true;

        fromLua = [
          { } { paths = ./luasnip; }
        ];

        fromVscode = lib.mkForce [
          { exclude = [ "latex" ]; }
        ];

        settings = {
          # Improve writing speed.
          enable_autosnippets = true;

          # Visual selection magic.
          cut_selection_keys = "<Tab>";

          update_events = [
            # Improve visual feedback.
            "TextChanged" "TextChangedI"
          ];

          # Keep a history.
          link_children = true;
          keep_roots = true;
        };
      };

    };

  };
}
