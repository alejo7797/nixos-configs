{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.myHome.geogebra;
in

{
  options.myHome.geogebra.enable = lib.mkEnableOption "GeoGebra";

  config = lib.mkIf cfg.enable {

    xdg.dataFile."mime/packages/geogebra-ggb.xml".source = ./geogebra-ggb.xml;

    home.activation.geogebra = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        ${pkgs.shared-mime-info}/bin/update-mime-database ${config.xdg.dataHome}/mime
      '';
    };

}
