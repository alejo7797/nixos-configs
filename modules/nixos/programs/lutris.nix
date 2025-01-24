{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.myNixOS.lutris;
in

{
  options.myNixOS.lutris.enable = lib.mkEnableOption "Lutris";

  config = lib.mkIf cfg.enable {

    environment.systemPackages = with pkgs; [

      (lutris.override {
        extraLibraries =  pkgs: with pkgs; [

          libgudev libvdpau speex

        ];
      })
    ];
  };
}
