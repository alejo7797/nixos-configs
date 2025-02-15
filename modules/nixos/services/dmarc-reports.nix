{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.myNixOS.dmarc-report-converter;
in

{
  options.myNixOS.dmarc-report-converter.enable = lib.mkEnableOption "DMARC Report Converter";

  config = lib.mkIf cfg.enable {

    systemd.services.dmarc-report-converter = {
      description = "";
      serviceConfig = {
        ExecStart = "${pkgs.dmarc-report-converter}/bin/dmarc-report-converter";
      };
    };

  };
}
