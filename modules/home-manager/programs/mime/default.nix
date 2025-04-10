{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.xdg.mimeApps;

  setListTo = value: list:
    builtins.listToAttrs
    (map (name: { inherit name value; }) list);
in

{
  options.xdg.mimeApps.my = {

    defaultWebBrowser = lib.mkOption {
      type = lib.types.str;
      default = "firefox.desktop";
      description = "Default web browser.";
    };

    defaultTextEditor = lib.mkOption {
      type = lib.types.str;
      default = "nvim.desktop";
      description = "Default text editor.";
    };

    defaultImageViewer = lib.mkOption {
      description = "Default image viewer.";
      type = lib.types.str;
      default = "org.kde.gwenview.desktop";
    };

    defaultMediaPlayer = lib.mkOption {
      type = lib.types.str;
      default = "mpv.desktop";
      description = "Default media player.";
    };

  };

  config = lib.mkIf cfg.enable {

    xdg = {

      dataFile."mime/packages" = {
        # Extra MimeTypes.
        source = ./packages;
        recursive = true;
      };

      mimeApps.defaultApplications =

        setListTo cfg.my.defaultWebBrowser [
          # Set the default browser.
          "application/x-extension-htm"
          "application/x-extension-html"
          "application/x-extension-shtml"
          "application/x-extension-xht"
          "application/x-extension-xhtml"
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
          # What Neovim advertises support for.
          "text/plain" "text/x-makefile"
          "text/x-c++hdr" "text/x-c++src"
          "text/x-chdr" "text/x-csrc"
          "text/x-java" "text/x-moc"
          "text/x-pascal" "text/x-tex"
          "application/x-shellscript"

          # And some extra associations.
          "text/html" "application/xml"
          "text/yaml" "application/json"
          "application/x-wine-extension-ini"
          "application/x-zerosize"
        ]

        // {
          # We like to use Zathura for PDF files.
          "application/pdf" = [ "org.pwmt.zathura-pdf-mupdf.desktop" cfg.my.defaultWebBrowser ];

          # We like to use Inkscape for SVG files.
          "image/svg+xml" = "org.inkscape.Inkscape.desktop";

          # Use WINE for Windows executables.
          "application/x-ms-dos-executable" = "wine.desktop";

          # Other applications might take Ark's spot otherwise.
          "application/zip" = "org.kde.ark.desktop";
        };

    };

    home.activation.mime-update = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ${pkgs.shared-mime-info}/bin/update-mime-database ${config.xdg.dataHome}/mime
    '';

  };
}
