{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.myHome.musescore;
in

{
  options.myHome.musescore.enable = lib.mkEnableOption "MuseScore";

  config = lib.mkIf cfg.enable {

    xdg.dataFile."mime/packages/musescore-mscz.xml".source = ./musescore-mscz.xml;

    home.activation.musescore = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ${pkgs.shared-mime-info}/bin/update-mime-database ${config.xdg.dataHome}/mime
    '';
  };

}
