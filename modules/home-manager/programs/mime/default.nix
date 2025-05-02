{ config, lib, pkgs, ... }:

let
  cfg = config.xdg.mimeApps;

  toINI = lib.generators.toINI { };

  setListTo = value: list: builtins.listToAttrs
    (map (name: { inherit name value; }) list);
in

{
  options.xdg.mimeApps.my = {

    defaultImageViewer = lib.mkOption {
      type = lib.types.str;
      description = "Default image viewer.";
      default = "org.kde.gwenview.desktop";
    };

    defaultMediaPlayer = lib.mkOption {
      type = lib.types.str;
      description = "Default media player.";
      default = "mpv.desktop";
    };

    defaultTerminalEmulator = lib.mkOption {
      type = lib.types.str;
      description = "Default terminal emulator.";
      default = "kitty.desktop";
    };

    defaultTextEditor = lib.mkOption {
      type = lib.types.str;
      description = "Default text editor.";
      default = "nvim.desktop";
    };

    defaultWebBrowser = lib.mkOption {
      type = lib.types.str;
      description = "Default web browser.";
      default = "firefox.desktop";
    };

  };

  config = lib.mkIf cfg.enable {

    home.packages = [
      # For default terminal.
      pkgs.xdg-terminal-exec
    ];

    xdg = {

      configFile = {
        "kdeglobals".text = toINI {
          General.TerminalApplication = # Desktop entry -> command.
            lib.removeSuffix ".desktop" cfg.my.defaultTerminalEmulator;
          };

        "xdg-terminals.list".text = ''
          ${cfg.my.defaultTerminalEmulator}
        '';
      };

      dataFile."mime/packages" = {
        # Extra MimeTypes.
        source = ./packages;
        recursive = true;
      };

      mimeApps.defaultApplications =

        setListTo cfg.my.defaultWebBrowser [
          "application/x-extension-htm"
          "application/x-extension-html"
          "application/x-extension-shtml"
          "application/x-extension-xht"
          "application/x-extension-xhtml"
          "text/html" # Not good.
          "x-scheme-handler/chrome"
          "x-scheme-handler/http"
          "x-scheme-handler/https"
        ]

        // setListTo cfg.my.defaultImageViewer [
          # Common image filetypes.
          "image/bmp" "image/gif"
          "image/heif" "image/jpeg"
          "image/png" "image/webp"
        ]

        // setListTo cfg.my.defaultMediaPlayer [
          # Common audio filetypes.
          "audio/aac" "audio/ac3" "audio/x-aiff"
          "audio/flac" "audio/mp4" "audio/mpeg"
          "audio/x-vorbis+ogg" "audio/vnd.wave"

          # Common video filetypes.
          "video/vnd.avi" "video/x-matroska"
          "video/quicktime" "video/mpeg"
          "video/mp4" "video/x-ms-wmv"
        ]

        // setListTo cfg.my.defaultTextEditor [
          # Neovim says these are good.
          "text/plain" "text/x-makefile"
          "text/x-c++hdr" "text/x-c++src"
          "text/x-chdr" "text/x-csrc"
          "text/x-java" "text/x-moc"
          "text/x-pascal" "text/x-tex"
          "application/x-shellscript"

          # And some extra file associations.
          "application/json" "application/xml"
          "application/x-wine-extension-ini"
          "application/x-zerosize" "text/yaml"
        ]

        //

        {
          "application/pdf" = [
            "org.pwmt.zathura-pdf-mupdf.desktop"
            cfg.my.defaultWebBrowser # Fallback.
          ];

          # Use Inkscape to open SVG files, when available.
          "image/svg+xml" = "org.inkscape.Inkscape.desktop";

          # Use WINE to run Windows executables under Linux.
          "application/x-ms-dos-executable" = "wine.desktop";

          # Give Ark priority when opening zip files.
          "application/zip" = "org.kde.ark.desktop";
        };

    };

    home.activation.mime-update = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ${lib.getExe' pkgs.shared-mime-info "update-mime-database"} ${config.xdg.dataHome}/mime
    '';

  };
}
