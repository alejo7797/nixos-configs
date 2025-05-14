{ config, lib, pkgs, ... }:

let
  cfg = config.hardware.my.intel-graphics;
in

{
  options.hardware.my.intel-graphics.enable = lib.mkEnableOption "Intel graphics";

  config = lib.mkIf cfg.enable {

    hardware = {

      graphics = {
        # Additional driver packages.
        extraPackages = with pkgs; [ intel-media-driver intel-compute-runtime vpl-gpu-rt ];
        extraPackages32 = with pkgs.pkgsi686Linux; [ intel-media-driver ];
      };

      intel-gpu-tools.enable = true;

    };

  };
}
