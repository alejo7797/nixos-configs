{ pkgs, lib, myLib, config, ... }: let

  cfg = config.myHome.mimeApps;

in {

  options.myHome.mimeApps = {

    enable = lib.mkEnableOption "filetype associations";

    defaultWebBrowser = lib.mkOption {
      description = "Default web browser application.";
      type = lib.types.str;
      default = "firefox.desktop";
    };

    defaultTextEditor = lib.mkOption {
      description = "Default text editor application.";
      type = lib.types.str;
      default = "nvim.desktop";
    };

    defaultImageViewer = lib.mkOption {
      description = "Default text editor application.";
      type = lib.types.str;
      default = "nvim.desktop";
    };

    defaultMediaPlayer = lib.mkOption {
      description = "Default media player application.";
      type = lib.types.str;
      default = "mpv.desktop";
    };

  };

  config.xdg.mimeApps = lib.mkIf cfg.enable {

    # Configure filetype associations.
    enable = true;

    # Set default applications.
    defaultApplications = with myLib;

      setListTo cfg.defaultWebBrowser [
        # Enough to set Firefox as default.
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
        "video/mp4" "video/webm" "video/x-ms-wmv"
      ]

      // setListTo cfg.defaultTextEditor [
        # What NeoVim advertises support for.
        "text/plain" "text/x-makefile"
        "text/x-c++hdr" "text/x-c++src"
        "text/x-chdr" "text/x-csrc"
        "text/x-java" "text/x-moc"
        "text/x-pascal" "text/x-tex"
        "application/x-shellscript"

        # And some extra associations.
        "text/html" "application/xml"
      ]

      // {
        # We like to use Inkscape for SVG files.
        "image/svg+xml" = "org.inkscape.Inkscape.desktop";
      };

  };
}
