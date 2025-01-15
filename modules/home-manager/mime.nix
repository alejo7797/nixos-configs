{
  lib,
  config,
  ...
}:

let
  cfg = config.myHome.mimeApps;
  setListTo = value: list:
    builtins.listToAttrs
    (map (name: { inherit name value; }) list);
in

{
  options.myHome.mimeApps = {

    enable = lib.mkEnableOption "filetype associations";

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

  config.xdg.mimeApps = lib.mkIf cfg.enable {

    enable = true;

    associations.added = {
      "application/pdf" = cfg.defaultWebBrowser;
    };

    defaultApplications =

      setListTo cfg.defaultWebBrowser [
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

      // setListTo cfg.defaultImageViewer [
        # Common image filetypes.
        "image/bmp" "image/gif"
        "image/heif" "image/jpeg"
        "image/png" "image/webp"
      ]

      // setListTo cfg.defaultMediaPlayer [
        # Common audio filetypes.
        "audio/aac" "audio/ac3" "audio/x-aiff"
        "audio/flac" "audio/mp4" "audio/mpeg"
        "audio/x-vorbis+ogg" "audio/vnd.wave"

        # Common video filetypes.
        "video/vnd.avi" "video/x-matroska"
        "video/quicktime" "video/mpeg"
        "video/mp4" "video/x-ms-wmv"
      ]

      // setListTo cfg.defaultTextEditor [
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
        "application/pdf" = "org.pwmt.zathura.desktop";

        # We like to use Inkscape for SVG files.
        "image/svg+xml" = "org.inkscape.Inkscape.desktop";

        # Use WINE for Windows executables.
        "application/x-ms-dos-executable" = "wine.desktop";
      };

  };
}
